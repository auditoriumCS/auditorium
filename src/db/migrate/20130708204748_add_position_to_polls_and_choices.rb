class AddPositionToPollsAndChoices < ActiveRecord::Migration
  def change
    add_column :polls, :position, :int, default: 0
    add_column :choices, :position, :int, default: 0
  end
end
