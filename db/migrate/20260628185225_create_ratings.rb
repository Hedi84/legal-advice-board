class CreateRatings < ActiveRecord::Migration[8.1]
  def change
    create_table :ratings do |t|
      t.references :answer, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :rating, null: false
      t.datetime :rated_at, null: false

      t.timestamps
    end

    add_index :ratings, [ :answer_id, :user_id ], unique: true
  end
end
