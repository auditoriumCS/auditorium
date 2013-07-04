class ChangeChoiceIdInPollResults < ActiveRecord::Migration
  change_table :poll_results do |t|
      t.rename :choiceId, :choice_id
    end
end
