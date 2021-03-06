class CreatePollRules < ActiveRecord::Migration
  def change
    create_table :poll_rules, :id => false do |t|
      t.uuid :id, :primary_key => true
      t.uuid :poll_id
      t.uuid :choice_id
      t.integer :position, :default => 0
    end
  end
end
