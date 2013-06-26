class CreatePollResults < ActiveRecord::Migration
  def change
    create_table :poll_results do |t|
      t.integer :userId
      t.uuid :questionId
      t.uuid :choiceId
      t.timestamps
    end
  end
end
