class AddViewersToEvents < ActiveRecord::Migration
  def change
    add_column :events, :viewers, :int
  end
end
