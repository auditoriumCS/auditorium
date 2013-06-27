class Event < ActiveRecord::Base
  has_many :periods # raum und zeit
  has_many :polls

  belongs_to :course
  belongs_to :tutor, class_name: 'User'

  attr_accessible :course_id, :tutor_id, :event_type # lecture, exercise, seminar, lab
  attr_accessible :weekday, :beginDate, :version, :endDate, :chat_active, :week, :url, :building, :room, :active_slide
  attr_accessible :polls
  
  validates :event_type,  presence: true,
                    inclusion: { in: %w{lecture exercise seminar lab} }
  validates :course,  presence: true
  validates :tutor, presence: true

  	# makes a String from every attribute within the model
	def to_s
    result = ""
    result << read_attribute(:event_type)
    result << " on "
    result << read_attribute(:beginDate).to_s

  		#attributes.each_with_object("") do |attribute, result|
    	#	result << "#{attribute[1].to_s} "
  		#end
	end
end
