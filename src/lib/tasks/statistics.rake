namespace :statistics do
  desc "Export pilot event statistics."
  task :export => :environment do

    puts "Email\tEvent\tUUID\tTyp\tText\tAuswahl\tRichtig/Falsch\tFeedbacktext\tNachricht"
    PollResult.all.each do |poll_result|
      user = User.find(poll_result.user_id)
      polls = Poll.where(id: poll_result.poll_id)
      choices = Choice.where(id: poll_result.choice_id)
      
      if poll = polls.first.presence and choice = choices.first.presence
        rule = PollRule.where(choice_id: choice.id).first
        message = Poll.where(id: rule.poll_id).first if rule.presence

        choice_type = 'Umfrage'
        poll.choices.each do |c|
          if c.is_correct
            choice_type = 'Lernaufgabe'
          end
        end
        if poll.event_id = 12 and user.email =~ /\bstudent([5-9][0-9])@tu-dresden.de\b/
          event = Event.find(poll.event_id)
          course = Course.find(event.course_id)
          puts "\"#{user.email}\"\t\"#{course.name if course.presence}\"\t\"#{poll.id}\"\t\"#{choice_type}\"\t\"#{poll.questiontext}\"\t\"#{choice.answertext}\"\t#{(choice.is_correct? ? 'RICHTIG' : 'FALSCH') if choice_type.eql? 'Lernaufgabe'}\t\"#{choice.feedback}\"\t\"#{message.questiontext if message.presence}\""
        end
      end
    end
  end
end

# create_table "polls", :force => true do |t|
#    t.text    "questiontext"
#    t.integer "event_id"
#    t.integer "time_to_answer"
#    t.boolean "poll_enabled",   :default => false, :null => false
#    t.boolean "result_enabled", :default => false, :null => false
#    t.integer "on_slide"
#    t.integer "position",       :default => 0
#  end

# create_table "choices", :force => true do |t|
#   t.text    "answertext",                      :null => false
#   t.boolean "is_correct",                      :null => false
#   t.uuid    "poll_id",                         :null => false
#   t.text    "feedback"
#   t.integer "on_slide"
#   t.boolean "feedback_enabled"
#   t.integer "position",         :default => 0
# end

# create_table "feedbacks", :force => true do |t|
#   t.text     "content"
#   t.datetime "created_at",                    :null => false
#   t.datetime "updated_at",                    :null => false
#   t.boolean  "read",       :default => false
# end

# create_table "poll_rules", :force => true do |t|
#   t.uuid    "poll_id"
#   t.uuid    "choice_id"
#   t.integer "position",  :default => 0
# end