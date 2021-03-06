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
			c["count"] = PollResult.select("COUNT(*) AS count").where("choice_id = 0x#{e.id.hexdigest}").count
			total += c["count"].to_i
			@p["choices"] << c
		end
		@p["total"] = total
		
	end
	
	def new
		@p = Poll.find(params[:pollId])
		@poll_result = PollResult.new

		respond_to do |format|
		  format.html  #new.html.erb
		end
	end
	
	def showjax
		r = Hash.new
		event = Event.find(params[:id])
		event.polls.each do |poll|

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
			r[poll.id] = p
		end
		
		respond_to do |format|
		  format.json { render :json => r }
		end

	end

	def rtc_create
		r = JSON.parse(request.body.read)
		pr = PollResult.create()
		
		puts "+++++++++++++current_user++++++++++"
		puts current_user
		
		puts "+++++++++++++++session+++++++++++++++"
		puts session

		#pr.user_id = current_user.id
		pr.user_id = current_user.id
		pr.poll_id = r['poll_id']
		pr.choice_id = r['choice_id']
		pr.answer_time = r['t_delta']

		pr.save
		
		choice = Choice.find(r['choice_id'])
		choice.poll_result << pr
		choice.save
		
		res = Hash.new 
		res['success'] = true

		#Can try again?
		poll = Poll.find(r['poll_id'])
		res_count = PollResult.where(poll_id: poll).where(user_id: current_user).count
        decisive = false
        poll.choices.each do |c|
          #puts "++++#{c.is_correct}==#{poll.choices.first.is_correct}"
          if poll.choices.first.is_correct != c.is_correct

              decisive = true
          end
        end
        res_correct = PollResult.where(poll_id: poll.id).where("user_id = #{current_user.id}").joins("INNER JOIN choices ON choices.id = poll_results.choice_id").where("choices.is_correct = true").count
        if poll.poll_enabled && (decisive && (res_count < 2 && res_correct < 1) || !decisive && res_count < 1) || current_user.admin
          res['can_try_again'] = true
        else
        	res['can_try_again'] = false
        end
        #puts "##++++#{poll.questiontext}+++++++++++#{decisive}+++++++++++++++#{(!decisive && res_count < 1).to_s}++++++++++++++++++++++++++++++++++++++#{res_count.to_s}"

		
		res['is_correct'] = choice.is_correct
		res['msg'] = choice.feedback
		respond_to do |format|
		  format.json  { render :json => res}
		end
	end

	def create
		pr = PollResult.create()
		pr.userId = current_user.id
		pr.questionId = params[:poll_result][:pollId]
		pr.choice_id = params[:choice_id]
		pr.save
		
		choice = Choice.find(params[:choice_id])
		choice.poll_result << pr
		choice.save
		
		respond_to do |format|
		  format.html  { redirect_to "/events/#{params[:poll_result][:eventId]}"}
		end
	end
end		