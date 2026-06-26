class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.integer :status
      t.datetime :approved_at
      t.references :requester, null: false, foreign_key: { to_table: :users }
      t.references :answer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
