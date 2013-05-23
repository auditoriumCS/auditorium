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
	
		@poll = Poll.find(params[:id])
		@p = Hash.new
		@p["text"] = @poll.questiontext;
		@p["choices"] = Array.new
		total = 0;
		
		@poll.choices.each do |e|
			c = Hash.new
			c["text"] = e.answertext
			c["correct"] = e.is_correct
			c["correct_class"] = (e.is_correct) ? "correct" : "incorrect" 
			c["count"] = PollResult.select("COUNT(*) AS count").where("choiceId = #{e.id}").count
			total += c["count"].to_i
			@p["choices"] << c
		end
		@p["total"] = total
		
	end
	
	def new
		@p = Poll.find(params[:questionId])
		@poll_result = PollResult.new

		respond_to do |format|
		  format.html  #new.html.erb
		end
	end
	
	def ajax_refresh
		@poll = Poll.find(:id)
		@p = {}
		@p.text = @poll.questiontext;
		
		@c = {}
		
		Poll.choices.each do |c|
			
		end
		
		format.js

	end

	def create
		pr = PollResult.create()
		pr.userId = params[:poll_result][:userId]
		pr.questionId = params[:poll_result][:questionId]
		pr.choiceId = params[:choiceId]
		pr.save
		
		choice = Choice.find(params[:choiceId])
		choice.poll_result << pr
		choice.save
		
		respond_to do |format|
		  format.html  show.html.erb
		  format.json  { render :json => @pr,
						:status => :created, :location => @pr }
		end
	end
end		