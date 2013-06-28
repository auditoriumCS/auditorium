class AddPollsTable < ActiveRecord::Migration
  def change
    create_table :polls, :id => false do |t|
      t.uuid :id, :primary_key => true
      t.string :questiontext
    end
  end
end