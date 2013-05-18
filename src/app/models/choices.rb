# A Poll represents the question
# A Choice represents the answer

class Choice < ActiveRecord::Base
  # adds a foreign_key of polls to choices 
  belongs_to :polls
  has_many :poll_result


  attr_accessible :answertext, :is_correct, :poll_result, :poll_id
  validates :answertext,  :presence => true
  validates :is_correct,  :presence => true

  	# makes a String from every attribute within the model
	def to_s
  		attributes.each_with_object("") do |attribute, result|
    		result << "#{attribute[1].to_s} "
  		end
	end  

end