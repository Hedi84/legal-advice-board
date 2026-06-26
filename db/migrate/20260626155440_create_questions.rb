class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.string :category, null: false
      t.integer :status, null: false, default: 0

      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :questions, :status
    add_index :questions, :category
  end
end