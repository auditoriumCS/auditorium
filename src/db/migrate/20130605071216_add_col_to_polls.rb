class AddColToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :time_to_answer, :integer
    add_column :polls, :poll_enabled, :boolean, :null => false, :default => false
    add_column :polls, :result_enabled, :boolean, :null => false, :default => false
    add_column :polls, :slide_id, :integer
    add_column :polls, :version, :integer, :null => false, :default => 1
  end
end
