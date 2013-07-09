class ChangeQuestiontextTypeToTextInPolls < ActiveRecord::Migration
  change_table :polls do |t|
    t.change :questiontext, :text
  end
end
