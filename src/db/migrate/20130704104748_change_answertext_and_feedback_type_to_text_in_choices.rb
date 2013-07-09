class ChangeAnswertextAndFeedbackTypeToTextInChoices < ActiveRecord::Migration
  change_table :choices do |t|
    t.change :answertext, :text
    t.change :feedback, :text
  end
end
