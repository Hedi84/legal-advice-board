class CreateAnswers < ActiveRecord::Migration[8.1]
  def change
    create_table :answers do |t|
      t.text :response
      t.integer :fee_pounds
      t.references :question, null: false, foreign_key: true
      t.references :lawyer, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
