class Choice < ActiveRecord::Base
  include ActiveUUID::UUID
  # adds a foreign_key of polls to choices 
  belongs_to :polls
  has_many :poll_result


  attr_accessible :answertext, :is_correct, :poll_result, :poll_id, :version, :feedback
  validates :answertext,  :presence => true
  # validation presence throws an error if :is_correct => false ... thats why we should avoid it.
  validates :is_correct, :inclusion => {:in => [true, false]}

  	# makes a String from every attribute within the model
	def to_s
  		attributes.each_with_object("") do |attribute, result|
    		result << "#{attribute[1].to_s} "
  		end
	end  

end