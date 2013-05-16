class PollResultsController < InheritedResources::Base

	def index
		poll = Poll.find(params[:id])
		@poi = poll.choices
	end		
	
	def new
		@poll_result = PollResult.new

		respond_to do |format|
		  format.html  # new.html.erb
		  format.json  { render :json => @poll }
		end
	end
end		