class ChangeFeePoundsOnAnswers < ActiveRecord::Migration[8.1]
  def change
    rename_column :answers, :fee_pounds, :proposed_fee_pounds

    change_column :answers,
                  :proposed_fee_pounds,
                  :decimal,
                  precision: 8,
                  scale: 2,
                  null: false
  end
end
