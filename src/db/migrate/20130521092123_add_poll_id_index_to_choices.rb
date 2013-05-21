class AddPollIdIndexToChoices < ActiveRecord::Migration
  def change
  	add_index :choices, :poll_id
  end
end
