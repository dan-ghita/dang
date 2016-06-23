class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.boolean :line_numbers
      t.boolean :auto_indent
      t.boolean :auto_correct
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
