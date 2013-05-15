# A Poll represents the question
# A Choice represents the answer

class Poll < ActiveRecord::Base
  has_many :choices
  # adds this key as a foreign_key into choices
  # has_one:polls_choices, :through => :choices
  # adds a foreign_key of events to polls 
  # belongs_to:events



  attr_accessible :questiontext, :choices
  validates :questiontext,  :presence => true

  def new_choice_attributes=(choice_attributes)
  	choice_attributes.each do |attributes|
    	choice.build(attributes)
  	end
  end

after_update :save_choices
  
  def existing_choice_attributes=(choice_attributes)
    choices.reject(&:new_record?).each do |choice|
      attributes = choice_attributes[choice.id.to_s]
      if attributes
        choice.attributes = attributes
      else
        choices.delete(choice)
      end
    end
  end
  
  def save_tasks
    choices.each do |choice|
      choice.save(false)
    end
  end


end