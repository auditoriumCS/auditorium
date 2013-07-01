class AddActiveSlideToEvents < ActiveRecord::Migration
  def change
    add_column :events, :active_slide, :uuid
  end
end
