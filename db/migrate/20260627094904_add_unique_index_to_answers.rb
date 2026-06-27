class AddUniqueIndexToAnswers < ActiveRecord::Migration[8.1]
  def change
    add_index :answers, %i[question_id lawyer_id], unique: true
  end
end
