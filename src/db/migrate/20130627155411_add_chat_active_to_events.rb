class AddChatActiveToEvents < ActiveRecord::Migration
  def change
    add_column :events, :chat_active, :int
  end
end
