class PollsController < ApplicationController

  def initpoll

 poll = Poll.create(:questiontext => "What is the meaning of life?", :event_id => 2)

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


  poll2 = Poll.create(:questiontext => "To be or not to be!", :event_id => 2)

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
  

  #TODO: one of the answers must be correct

  respond_to do |format|
    if @poll.save

      @choice = Choice.new(params[:choice])
      @choice.poll_id = @poll.id

      if @choice.save
          format.html  { redirect_to(@poll,
                    :notice => 'poll and its choices were successfully created.') }
          format.json  { render :json => @poll,
                    :status => :created, :location => @poll }
      # cant save choice
      else
        # redirect_to( { :action => "show", :id => @project }, { :notice => 'Project was successfully created.' } )
        format.html  { redirect_to( { :id => @poll, :action => "edit" }, 
                                    {:notice => 'Created poll without any answers. Please add answers now.' }) }
        format.json  { render :json => @choice.errors,
                    :status => :unprocessable_entity }
      end
    else
      format.html  { render :action => "new" }
      format.json  { render :json => @poll.errors,
                    :status => :unprocessable_entity }
    end
  end
end

def show
  @poll = Poll.find(params[:id])
 
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


    @poll.destroy

    respond_to do |format|
      format.html { redirect_to(@poll, :notice => 'poll was successfully destroyed.') }
      format.json { head :no_content }
    end
  end

def update 
  #params[:poll][:existing_choice_attributes] ||= {}
  @poll = Poll.find(params[:id])

  if @poll.update_attributes(params[:poll])
      flash[:notice] = "Successfully updated poll."
      redirect_to @poll
  else
      render :action => 'edit'
  end
end


end