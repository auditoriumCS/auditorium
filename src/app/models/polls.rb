class Poll < ActiveRecord::Base
  has_many :choices, :dependent => :destroy
  # has_one :polls_choices, :through => :choices
  belongs_to :events

  accepts_nested_attributes_for :choices, :reject_if => lambda { |a| a[:answertext].blank? }, :allow_destroy => true
  attr_accessible :questiontext, :choices, :event_id, :choices_attributes, :time_to_answer, :poll_enabled, :result_enabled, :slide_id, :version
  validates :questiontext,  :presence => true
  validates :event_id,  :presence => true

end