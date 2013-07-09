class AddVersionAndModifiedToEvents < ActiveRecord::Migration
  def up
    Event.reset_column_information
    if Event.column_names.include?('version')
      change_column :events, :version, :int, default: 0, null: false
    else
      add_column :events, :version, :int, default: 0, null: false
    end
    add_column :events, :modified, :boolean, default: false, null: false
  end
  def down
    change_table :events do |t|
      t.remove :version
      t.remove :modified
    end
  end
end
