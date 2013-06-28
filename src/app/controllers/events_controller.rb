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
    if !session['logged_in_events'][:id]
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
    #r = JSON.parse(request.body.read)
    # test
    slideId = '34390000-0000-0000-0000-000000000000'
    event = Event.find(params[:id])
    event.active_slide = slideId

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
  # retrieve event as JSON
  def get_json
  	@event = Event.find(params[:id])
  	respond_to do |format|
  		format.json { render :json => @event.to_json(:include =>{ :polls => {:include => :choices}})}
    end
  end
  
  # POST /events/push/x.json
  def post_json
  	r = JSON.parse(request.body.read)
    e = Event.find(params[:id])
    e.version = r['version'].to_i
    pids = Hash.new
    cids = Hash.new

    # Add and modify all polls and choices in given event
    r['polls'].each do |rp|
      pids[rp['id']] = true
      begin
        p  = Poll.find(rp['id'])
      rescue 
        p = Poll.new
        p.id = rp['id']
        p.event_id = e['id']
      end 
      
      p.questiontext = rp['questiontext']
      p.version = rp['version']
      p.on_slide  = rp['on_slide'] 
      rp['choices'].each do |rc|
        cids[rc['id']] = true
        begin
          c = Choice.find(rc['id'])
        rescue
          c = Choice.new
          c.poll_id = rp['id']
          c.id = rc['id']
          p.choices << c
        end 
        c.answertext = rc['answertext']
        c.version = rc['version']
        c.is_correct = rc['is_correct'] 
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
    e = Event.find(params[:id])

    # respond_to do |format|
    #   format.json { render :json => e.to_json(:include =>{ :polls => {:include => :choices}})}
    # end
	 respond_to do |format|
	 	format.json { render :success => true}
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
  def rtc
    res = Hash.new
    e = Event.find(params[:id])
    polls = e.polls
    res['polls'] = Array.new
    res['poll_results'] = Array.new
    polls.each do |poll|
      if poll.poll_enabled
        res['open_polls'] << poll
      end
      if p.result_enabled
        p = Hash.new
        p["text"] = poll.questiontext;
        p["choices"] = Array.new
        total = 0;
        
        poll.choices.each do |e|
          c = Hash.new
          c["text"] = e.answertext
          c["correct"] = e.is_correct
          c["correct_class"] = (e.is_correct) ? "correct" : "incorrect" 
          c["count"] = PollResult.select("COUNT(*) AS count").where("choice_id = 0x#{e.id.hexdigest}").count
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
    res['viewers'] = e.viewers

    respond_to do |format|
      format.json { render :json => res}
    end  
  end



  #POST /events/:id/pushMsgToProf.json 
  def push_msg_to_prof
    r = JSON.parse(request.body.read)
    e = Event.find(params[:id])
    
    e.prof_comprehensibility = e.prof_comprehensibility + r['prof_comprehensibility'].to_i
    e.prof_speed = e.prof_speed  + r['prof_speed'].to_i
    e.prof_volume = e.prof_volume + r['prof_volume'].to_i

    respond_to do |format|
      format.json { render :success => true}
    end
  end
  
  #POST /events/:id/logout
  def viewer_logout
    e = Event.find(params[:id])
    e.viewers = e.viewers - 1
    e.save

    respond_to do |format|
      format.json { render :success => true}
    end
  end

  #POST /events/:id/setChatActive
  def set_chat_active
    r = request.body.read  
    e = Event.find(params[:id])
    e.chat_active = r.chat_active
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
