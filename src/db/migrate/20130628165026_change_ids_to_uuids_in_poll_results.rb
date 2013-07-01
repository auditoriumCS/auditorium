class ChangeIdsToUuidsInPollResults < ActiveRecord::Migration
  change_table :poll_results do |t|
      t.change :poll_id, :uuid
      t.change :choice_id, :uuid
    end
end
