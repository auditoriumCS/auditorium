class AddVersionToChoices < ActiveRecord::Migration
  def change
    add_column :choices, :version, :integer, :null => false, :default => 1
  end
end
