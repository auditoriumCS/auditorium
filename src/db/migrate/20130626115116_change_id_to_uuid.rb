class ChangeIdToUuid < ActiveRecord::Migration
  def change

    change_table :choices, :id => false do |t|
      t.change :id,:uuid
      t.change :poll_id, :uuid
    end

    change_table :polls, :id => false do |t|
      t.change :id, :uuid
    end

    change_table :poll_results do |t|
      t.rename :userId, :user_id
      t.rename :questionId, :poll_id
    end

    add_column :choices, :version, :int
    add_column :poll_results, :answer_time, :int
  end
end