class AddEventIdToPoll < ActiveRecord::Migration
  def change
    add_column :polls, :event_id, :integer
    add_index :polls, :event_id
  end
end
