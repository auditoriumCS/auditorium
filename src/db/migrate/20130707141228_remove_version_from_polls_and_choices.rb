class RemoveVersionFromPollsAndChoices < ActiveRecord::Migration
  def change
    remove_column :polls, :version
    remove_column :choices, :version
  end
end
