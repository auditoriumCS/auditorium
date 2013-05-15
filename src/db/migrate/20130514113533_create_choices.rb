class CreateChoices< ActiveRecord::Migration
  def change
    create_table :choices do |t|
      t.string  :answertext, :null => false
      t.boolean :is_correct, :null => false
      t.references :poll, :null => false
    end
  end
end