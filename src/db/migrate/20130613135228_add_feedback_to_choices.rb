class AddFeedbackToChoices < ActiveRecord::Migration
  def change
    add_column :choices, :feedback, :string
  end
end
