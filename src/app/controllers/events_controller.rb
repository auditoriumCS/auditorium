class EventsController < ApplicationController

  load_and_authorize_resource

  # GET /events
  # GET /events.json
  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    #@event.prof_comprehensibility = 0
    #@event.prof_speed = 0
    #@event.prof_volume = 0
    @event.viewers = 10
    if session['active_slide'] != nil
      if @event.active_slide != session['active_slide']
        session['active_slide'] = @event.active_slide
        session['prof_speed_canVote'] = true
        session['prof_comprehensibility_canVote'] = true
        session['prof_volume_canVote'] = true
      end
    else  
      session['active_slide'] = @event.active_slide
      session['prof_speed_canVote'] = true
      session['prof_comprehensibility_canVote'] = true
      session['prof_volume_canVote'] = true
    end 

    if session['logged_in_events'] == nil
      session['logged_in_events'] = Hash.new
    end

    if session['logged_in_events'][:id] == nil
      session['logged_in_events'][:id] = true
      @event.viewers = @event.viewers + 1
    end

    @event.save

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    @types = ['lecture', 'excercise', 'seminar', 'lab']
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /events/1/update_slide
  def update_slide
    r = JSON.parse(request.body.read)
    event = Event.find(params[:id])
    event.active_slide = r["slide_id"]

    #zero out prof feedback on slide change
    event.prof_comprehensibility = 0
    event.prof_speed = 0
    event.prof_volume = 0

    respond_to do |format|
      if event.save

        
        event.polls.each do |p|

          #check for polls
          if p.on_slide == event.active_slide
            p.poll_enabled = true
            p.save
          end

          #check for feedback
          p.choices.each do |c|
            if c.on_slide == event.active_slide
              # TODO: set feedback_enabled false on create and update
              c.feedback_enabled = true
              c.save
            end
          end

        end

        format.json { render json: event, status: :updated, location: event }
      else
        format.json { render json: event.errors, status: :unprocessable_entity }
      end
    end

  end

  # GET /events/pull/x.json
  # POST /events/pull/x.json
  # retrieve event as JSON
  # sets event.modified to false if requested with HTTP method POST
  def pull_json
    @event = Event.find(params[:id])
    if request.post?
      @event.modified = false
      @event.save!
    end
    respond_to do |format|
      format.json { render :json => @event.to_json(:include =>{ :polls => {:include => :choices}})}
    end
  end
  
  # POST /events/push/x.json
  def push_json 
    r = JSON.parse(request.body.read)
    e = Event.find(params[:id])
    e.version = r['version'].to_i
    e.modified = false;
    pids = Hash.new
    cids = Hash.new

    # Add and modify all polls and choices in given event
    r['polls'].each do |rp|
      pids[rp['id'].to_s.gsub("-", "").upcase] = true
      begin
        p  = Poll.find(rp['id'])
      rescue 
        p = Poll.new
        p.id = rp['id']
        p.event_id = e['id']
      end 
      
      p.questiontext = rp['questiontext']
      p.on_slide  = rp['on_slide'] 
      p.position = rp['position']
      rp['choices'].each do |rc|
        cids[rc['id'].to_s.gsub("-", "").upcase] = true
        begin
          c = Choice.find(rc['id'])
        rescue
          c = Choice.new
          c.poll_id = rp['id']
          c.id = rc['id']
          p.choices << c
        end 
        c.answertext = rc['answertext']
        c.feedback = rc['feedback']
        c.is_correct = rc['is_correct'] 
        c.position = rc['position']
        c.save!
      end
      p.save!      
    end
    

    # wipe out the rest
    e.polls.each do |p|
      p.choices.each do |c|
        if !cids[c.id.to_s.gsub("-", "").upcase]
          c.destroy
        end
      end
      if !pids[p.id.to_s.gsub("-", "").upcase]
        p.destroy
      end
    end
    
    e.save!

    res = Hash.new 
    res['success'] = true
    respond_to do |format|
      format.json { render :json => res}
    end
  end
  
  # GET /events/check/x.json
  def check_version
  	@event = Event.find(params[:id])
  	respond_to do |format|
  		format.json { render :version => @event.version, :updated_at => @event.updated_at}
  	end
  end
  
  #GET /events/:id/rtc
  def realtime_client
    res = Hash.new
    e = Event.find(params[:id])
    polls = e.polls
    res['open_polls'] = Array.new
    res['poll_results'] = Array.new
    polls.each do |poll|
      res_count = PollResult.where(poll_id: poll).where(user_id: current_user).count
      res_correct = PollResult.where(poll_id: poll.id).where("user_id = #{current_user.id}").joins("INNER JOIN choices ON choices.id = poll_results.choice_id").where("choices.is_correct = true").count
      if poll.poll_enabled && (res_count < 3 && res_correct < 1) || current_user.admin
        res['open_polls'] << poll
      end
      if poll.result_enabled || current_user.admin
        p = Hash.new
        p["text"] = poll.questiontext;
        p['poll_enabled'] = poll.poll_enabled
        p['result_enabled'] =  poll.result_enabled
        p['id'] = poll.id
        p["choices"] = Array.new
        total = 0;
        
        poll.choices.sort_by(&:position).each do |e|
          c = Hash.new
          c["text"] = e.answertext
          c["correct"] = e.is_correct
          c["correct_class"] = (e.is_correct) ? "correct" : "incorrect" 
          c["count"] = e.poll_result.count
          total += c["count"].to_i
          p["choices"] << c
        end
        p["total"] = total
        res['poll_results'] << p
      end
    end

    res['chat_active'] = e.chat_active

    res['prof_comprehensibility'] = e.prof_comprehensibility 
    res['prof_speed'] = e.prof_speed 
    res['prof_volume']  = e.prof_volume 

    res['prof_comprehensibility_canVote']  = session['prof_comprehensibility_canVote']
    res['prof_speed_canVote'] = session['prof_speed_canVote']
    res['prof_volume_canVote'] = session['prof_volume_canVote']

    res['viewers'] = e.viewers

    if(res['active_slide'] != e.active_slide)
      session['prof_comprehensibility_canVote'] = true
      session['prof_speed_canVote'] = true
      session['prof_volume_canVote'] = true

      f = Poll.joins("INNER JOIN poll_rules ON poll.id = poll_rules.poll_id").joins("INNER JOIN poll_results ON poll_rules.choice_id = poll_results.choice_id").where("poll_results.user_id = #{current_user.id}").first
      if(f.questiontext != nil)
        res['feedback'] = f.questiontext
      end
    end

    res['active_slide'] = e.active_slide
    res['x-csrf'] = request.session_options[:id]


    respond_to do |format|
      format.json { render :json => res.to_json( :include => :choices)}
    end  
  end



  #POST /events/:id/prof_control.json 
  def push_msg_to_prof
    r = JSON.parse(request.body.read)
    e = Event.find(params[:id])
    
    if r['comprehensibility'] != nil && session['prof_comprehensibility_canVote']
      e.prof_comprehensibility = e.prof_comprehensibility + r['comprehensibility'].to_i
      session['prof_comprehensibility_canVote']  =false
    end

    if r['speed'] != nil && session['prof_speed_canVote']
      e.prof_speed = e.prof_speed  + r['speed'].to_i
      session['prof_speed_canVote'] = false
    end
    if r['volume'] != nil && session['prof_volume_canVote']
      e.prof_volume = e.prof_volume + r['volume'].to_i
      session['prof_volume_canVote'] = false
    end
    e.save

    res = Hash.new 
    res['success']=true
    respond_to do |format|
      format.json { render :json => true}
    end
  end
  
  #POST /events/:id/logout
  def viewer_logout
    e = Event.find(params[:id])
    session['logged_in_events'][:id] = nil
    e.viewers = e.viewers - 1
    e.save
    res = Hash.new
    res['success']=true
    respond_to do |format|
      format.json { render :json => res}
    end
  end

  #POST /events/:id/setChatActive
  def set_chat_active
    r = request.body.read  
    e = Event.find(params[:id])
    e.chat_active = r['chat_active']
    e.save
    res = Hash.new
    res['success']=true
    respond_to do |format|
      format.json { render :json => res}
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end
end
