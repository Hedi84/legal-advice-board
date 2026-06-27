# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_27_094904) do
  create_table "answers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "fee_pounds"
    t.integer "lawyer_id", null: false
    t.integer "question_id", null: false
    t.text "response"
    t.datetime "updated_at", null: false
    t.index [ "lawyer_id" ], name: "index_answers_on_lawyer_id"
    t.index [ "question_id", "lawyer_id" ], name: "index_answers_on_question_id_and_lawyer_id", unique: true
    t.index [ "question_id" ], name: "index_answers_on_question_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "answer_id", null: false
    t.datetime "approved_at"
    t.datetime "created_at", null: false
    t.integer "requester_id", null: false
    t.integer "status"
    t.datetime "updated_at", null: false
    t.index [ "answer_id" ], name: "index_payments_on_answer_id"
    t.index [ "requester_id" ], name: "index_payments_on_requester_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "body", null: false
    t.string "category", null: false
    t.datetime "created_at", null: false
    t.integer "status", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index [ "category" ], name: "index_questions_on_category"
    t.index [ "status" ], name: "index_questions_on_status"
    t.index [ "user_id" ], name: "index_questions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index [ "email_address" ], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "users", column: "lawyer_id"
  add_foreign_key "payments", "answers"
  add_foreign_key "payments", "users", column: "requester_id"
  add_foreign_key "questions", "users"
end
