class ChangeIdToUuid < ActiveRecord::Migration
  def change

    
    add_column :choices, :version, :int
    add_column :poll_results, :answer_time, :int
  end
end