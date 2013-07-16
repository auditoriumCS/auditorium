class AddBeginAndEndTimeToEvents < ActiveRecord::Migration
  def change
    add_column :events, :beginTime, :time
    add_column :events, :endTime, :time
  end
end
