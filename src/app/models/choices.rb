# A Poll represents the question
# A Choice represents the answer

class Choice < ActiveRecord::Base
  # adds a foreign_key of polls to choices 
  belongs_to : polls
  has_many : poll_result


  attr_accessible :answertext, :is_correct, :poll_result
  validates :answertext,  :presence => true
  validates :is_correct,  :presence => true

end