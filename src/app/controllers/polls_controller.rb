class PollsController < ApplicationController

  # GET /polls
  # index.html.erb
  def index
    @polls = Poll.all

    poll = Poll.create(:questiontext => "A real question?")

    choice1 = Choice.new(
         :answertext => "NO",
          :is_correct => false
     ) 
    choice2 = Choice.new(
          :answertext => "YES",
          :is_correct => true
     )   

    poll.choices << choice1  
    poll.choices << choice2
 
    respond_to do |format|
      format.html  # index.html.erb
      format.json  { render :json => @polls }
    end
  end

  def new
    @poll = Poll.new
    @poll.choices.build
   
    respond_to do |format|
      format.html  # new.html.erb
      format.json  { render :json => @poll }
    end
  end

def create
  @poll = Poll.new(params[:poll])

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
  params[:poll][:existing_choice_attributes] ||= {}
  @poll = Poll.find(params[:id])
  if
    @poll.update_attributes(params[:poll])
    flash[:notice] =  "Successfully updated poll and choices."
    redirect_to project_path(@poll)
  else
    render :action =>  'edit'
  end
end

end