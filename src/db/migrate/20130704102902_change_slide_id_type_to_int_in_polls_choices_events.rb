class ChangeSlideIdTypeToIntInPollsChoicesEvents < ActiveRecord::Migration
  change_table :polls do |t|
    t.change :on_slide, :int
  end
  change_table :choices do |t|
    t.change :on_slide, :int
  end
  change_table :events do |t|
    t.change :active_slide, :int
  end
end
