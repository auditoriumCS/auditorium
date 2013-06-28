class AddAnswerTimeToPollResults < ActiveRecord::Migration
  def change
    add_column :poll_results, :answer_time, :int
  end
end
