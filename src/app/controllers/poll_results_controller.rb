class PollResultsController < InheritedResources::Base

	def index
		if params[:id]
			poll = Poll.find(params[:id])
		else
			poll = Poll.all
		end
		@poi = poll.choices
	end		
	
	def show
		if params[:id]
			poll = Poll.find(params[:id])
		else
			poll = Poll.all
		end
		@poi = poll.choices
	end
	
	def new
		@p = Poll.find(params[:questionId])
		@poll_result = PollResult.new

		respond_to do |format|
		  format.html  # new.html.erb
		end
	end
	
	def create
		pr = PollResult.create()
		pr.userId = params[:poll_result][:userId]
		pr.questionId = params[:poll_result][:questionId]
		pr.choiceId = params[:poll_result][:choiceId]
		pr.save
		
		choice = Choice.find(params[:poll_result][:choiceId])
		choice.poll_result << pr
		choice.save
		
		respond_to do |format|
		  format.html  # index.html.erb
		  format.json  { render :json => @pr,
						:status => :created, :location => @pr }
		end
	end
end		