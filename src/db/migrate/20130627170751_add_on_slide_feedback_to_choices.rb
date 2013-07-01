class AddOnSlideFeedbackToChoices < ActiveRecord::Migration
  def change
    add_column :choices, :on_slide, :uuid
  end
end
