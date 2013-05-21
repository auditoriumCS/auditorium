class PollsController < ApplicationController

  def initpoll

 poll = Poll.create(:questiontext => "What Time is it?", :event_id => 1)

    choice1 = Choice.create(
         :answertext => "Time to go",
         :is_correct => false,
         :poll_id => poll.id
     ) 
    choice2 = Choice.create(
          :answertext => "Time to dance",
          :is_correct => true,
         :poll_id => poll.id
     )   

     poll.choices << choice1  
     poll.choices << choice2


  poll2 = Poll.create(:questiontext => "What do you like?", :event_id => 1)

    choice1 = Choice.create(
         :answertext => "I like apples",
         :is_correct => false,
         :poll_id => poll2.id
     ) 
    choice2 = Choice.create(
          :answertext => "I like bananas",
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
    #@poll.choices.build
   
    respond_to do |format|
      format.html  # new.html.erb
      format.json  { render :json => @poll }
    end
  end

def create
  @poll = Poll.new(params[:poll])
  @choice = Choice.new(params[:choice])

  @poll.choices << @choice

  respond_to do |format|
    if @poll.save
      format.html  { redirect_to(@poll,
                    :notice => 'poll was successfully created.') }
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
 
  respond_to do |format|
    format.html  # show.html.erb
    format.json  { render :json => @poll }
  end
end

  # GET /polls/1/edit
  def edit
    @poll = Poll.find(params[:id])
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

  #@choice = Choice.find_all_by_poll_id(params[:id]).first


  if @poll.update_attributes(params[:poll])
    flash[:notice] +=  "Successfully updated poll."
    redirect_to poll_path(@poll)
  else
    render :action =>  'edit'
  end
end

end