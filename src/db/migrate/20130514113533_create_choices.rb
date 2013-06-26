class CreateChoices< ActiveRecord::Migration
  def change
    create_table :choices, :id => false do |t|
      t.uuid :id, :primary_key => true
      t.uuid :poll_id, :null => false
      t.string  :answertext, :null => false
      t.boolean :is_correct, :null => false
      t.references :poll, :null => false
    end
  end
end