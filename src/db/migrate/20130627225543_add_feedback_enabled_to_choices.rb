class AddFeedbackEnabledToChoices < ActiveRecord::Migration
  def change
    add_column :choices, :feedback_enabled, :boolean
  end
end
