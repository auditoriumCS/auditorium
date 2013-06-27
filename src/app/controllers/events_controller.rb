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
	r = request.body.read
  

  respond_to do |format|
    format.json { render :r => r}
  end
  
 #  e = Event.find(params[:id])
 #  e.version = r.version
 #  r.polls each do |rp|
 #    p  = Poll.find(rp.id)
 #    if p == null
 #      p = Poll.new
 #      p.id = rp.id
 #      p.questiontext = rp.questiontext
 #      p.event_id = e.id
 #      p.version = rp.version
 #      rp.choices each do |rc|

 #      end
 #      p.save
 #    else
 #      p.questiontext = rp.questiontext
 #      p.version = rp.version
 #      rp.choices each do |rc|

 #      end
 #      p.save
 #    end  
 #  end

	# respond_to do |format|
	# 	format.json { render :success => s, :error => @event.errors}
	# end
  end
  
  # GET /events/check/x.json
  def check_version
	@event = Event.find(params[:id])
	respond_to do |format|
		format.json { render :version => @event.version, :updated_at => @event.updated_at}
	end
  end
  
  #GET /events/:id/getVisibleContent
  def get_visible_content
    res = Hash.new
    e = Event.find(params[:id])
    polls = e.polls
    res['polls'] = Array.new
    res['poll_results'] = Array.new
    polls.each do |p|
      if p.poll_enabled
        res['polls'] << p.id
      end
      if p.result_enabled
        res['poll_results'] << p.id
      end
    end
    res['chat_active'] = e.chat_active

    respond_to do |format|
      format.json { render :json => res}
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
