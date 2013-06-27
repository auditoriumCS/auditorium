class AddOnSlideToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :on_slide, :uuid
  end
end
