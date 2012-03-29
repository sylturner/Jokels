# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120328030336) do

  create_table "achievements", :force => true do |t|
    t.string   "type"
    t.integer  "level"
    t.integer  "achievable_id"
    t.string   "achievable_type"
    t.integer  "ref_id"
    t.string   "ref_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "daily_words", :force => true do |t|
    t.string   "word"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favorite_jokes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "joke_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jokes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "question"
    t.string   "answer"
    t.integer  "user_id"
    t.integer  "up_votes",    :default => 0, :null => false
    t.integer  "down_votes",  :default => 0, :null => false
    t.string   "jokeler_url"
    t.string   "bitly_url"
  end

  create_table "users", :force => true do |t|
    t.string   "uid"
    t.string   "name"
    t.string   "provider"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_url"
    t.string   "url"
    t.integer  "up_votes",   :default => 0, :null => false
    t.integer  "down_votes", :default => 0, :null => false
    t.string   "token"
    t.string   "secret"
  end

  create_table "votings", :force => true do |t|
    t.string   "voteable_type"
    t.integer  "voteable_id"
    t.string   "voter_type"
    t.integer  "voter_id"
    t.boolean  "up_vote",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votings", ["voteable_type", "voteable_id", "voter_type", "voter_id"], :name => "unique_voters", :unique => true
  add_index "votings", ["voteable_type", "voteable_id"], :name => "index_votings_on_voteable_type_and_voteable_id"
  add_index "votings", ["voter_type", "voter_id"], :name => "index_votings_on_voter_type_and_voter_id"

end
