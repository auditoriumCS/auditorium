class RemoveOnSlideFromPolls < ActiveRecord::Migration
  def up
    remove_column :polls, :slide_id
  end

  def down
    add_column :polls, :slide_id, :int
  end
end
