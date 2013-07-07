class PollsController < ApplicationController

  def initpoll

 poll = Poll.create(
        :questiontext => "What is the meaning of life?", 
        :event_id => 2,
        :time_to_answer => 60)

    choice1 = Choice.create(
         :answertext => "42",
         :is_correct => false,
         :poll_id => poll.id
     ) 
    choice2 = Choice.create(
          :answertext => "21",
          :is_correct => true,
         :poll_id => poll.id
     )   

     poll.choices << choice1  
     poll.choices << choice2


  poll2 = Poll.create(
        :questiontext => "To be or not to be!", 
        :event_id => 2,
        :time_to_answer => 120)

    choice1 = Choice.create(
         :answertext => "To be",
         :is_correct => false,
         :poll_id => poll2.id
     ) 
    choice2 = Choice.create(
          :answertext => "not to be",
          :is_correct => true,
         :poll_id => poll2.id
     )   

     poll2.choices << choice1  
     poll2.choices << choice2



     # add ! to throw errors to console e.g. poll.save!
     poll2.save   
     poll.save

  end

  # GET /polls
  # index.html.erb
  def index

    if Poll.count == 0
      initpoll
    end  

    @polls = Poll.all

    respond_to do |format|
      format.html  # index.html.erb
      format.json  { render :json => @polls }
    end
  end

  def new
    @poll = Poll.new
    3.times do @poll.choices.build end
   
    respond_to do |format|
      format.html  # new.html.erb
      format.json  { render :json => @poll }
    end
  end

def create
  @poll = Poll.new(params[:poll])
  @poll.event_id = params[:poll][:event_id]

  

  respond_to do |format|
    if !is_singlebestchoice(@poll)
      format.html  { render :action => "new", :notice => 'poll needs to have one correct answer.'}
      format.json  { render :json => @poll.errors,
                    :status => :unprocessable_entity }

    elsif @poll.save
          @event = Event.find(@poll.event_id)
          @event.record_modification
          
          format.html  { redirect_to(@poll,
                    :notice => 'poll and its choices were successfully created.') }
          format.json  { render :json => @poll,
                    :status => :created, :location => @poll }
    else
      format.html  { render :action => "new" }
      format.json  { render :json => @poll.errors,
                    :status => :unprocessable_entity }
    end
  end
end

def show
  @poll = Poll.find(params[:id])
  @event = Event.find(@poll.event_id)
 
  respond_to do |format|
    format.html  # show.html.erb
    format.json  { render :json => @poll }
  end
end

  # GET /polls/1/edit
  def edit
    @poll = Poll.find(params[:id])
    @event = Event.find(@poll.event_id)
    @course = @event.course
    @choices = @poll.choices
  end

  # DELETE /polls/1
  # DELETE /polls/1.json
  def destroy
    @poll = Poll.find(params[:id])

    choices = Choice.find_all_by_poll_id(@poll.id)
    Choice.destroy(choices)

    @event = Event.find(@poll.event_id)
    @event.record_modification

    @poll.destroy

    respond_to do |format|
      format.html { redirect_to(@poll, :notice => 'poll was successfully destroyed.') }
      format.json { head :no_content }
    end
  end

def update 
  @poll = Poll.find(params[:id])

  if !is_singlebestchoice(@poll)
      flash[:notice] = "poll needs to have one correct answer."
      redirect_to @poll
  elsif @poll.update_attributes(params[:poll])
      @event = Event.find(@poll.event_id)
      @event.record_modification

      flash[:notice] = "Successfully updated poll."
      redirect_to @poll
  else
      render :action => 'edit'
  end
end

  # GET /polls/:id/toggle_visibility_of_poll
def toggle_visibility
  @poll = Poll.find(params[:id])
  @event = Event.find(@poll.event_id)

  @poll.poll_enabled = !@poll.poll_enabled
  @poll.save  

    respond_to do |format|
      format.html { redirect_to(@event, :notice => 'poll was successfully updated.') }
      format.json  { render :json => @poll.errors,
                    :status => :unprocessable_entity }
  end

end



  # GET /polls/:id/toggle_visibility_of_result
def toggle_result
  @poll = Poll.find(params[:id])
  @event = Event.find(@poll.event_id)

  @poll.result_enabled = !@poll.result_enabled
  @poll.save  

    respond_to do |format|
      format.html { redirect_to(@event, :notice => 'poll was successfully updated.') }
      format.json  { render :json => @poll.errors,
                    :status => :unprocessable_entity }
      end                
  end

  def is_singlebestchoice poll
    is_okay = true
    single = false
    poll.choices.each do |c|
      if c.is_correct && single
        is_okay = false
        # poll.errors.add(:choices, "cannot have more than one correct answer.")
      end

      if c.is_correct
        single = true
      end

    end

    if !single
      is_okay = false
      # poll.errors.add(:choices, "must have one correct answer.")
    end

    return is_okay
  end

# GET /polls/:id/is_visible
def is_visible
  res  = Map.new
  res['']
end  


# GET /polls/:id/is_result_visible
def is_result_visible
  res = Map.new
  res['visible'] = Poll.find(params[:id]).result_enabled
  respond_to do |format|
    format.json {render :json => res}
  end
end

end