class PollResult < ActiveRecord::Base
	belongs_to :choices
	attr_accessible :choice_id, :question_id, :user_id
end
