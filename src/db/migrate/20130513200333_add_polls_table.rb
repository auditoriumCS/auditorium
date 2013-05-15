class AddPollsTable < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :questiontext
    end
  end
end