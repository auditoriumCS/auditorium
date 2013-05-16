class CreatePollResults < ActiveRecord::Migration
  def change
    create_table :poll_results do |t|
      t.integer :userId
      t.integer :questionId
      t.integer :choiceId

      t.timestamps
    end
  end
end
