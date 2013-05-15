class PollResult < ActiveRecord::Base
  attr_accessible :choiceId, :questionId, :userId
end
