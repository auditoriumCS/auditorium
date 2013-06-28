class AddProfControlsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :prof_speed, :int
    add_column :events, :prof_volume, :int
    add_column :events, :prof_comprehensibility, :int
  end
end
