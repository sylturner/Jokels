# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20130421150909) do

  create_table "achievements", :force => true do |t|
    t.string   "type"
    t.integer  "level"
    t.integer  "achievable_id"
    t.string   "achievable_type"
    t.integer  "ref_id"
    t.string   "ref_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "alternate_punchlines", :force => true do |t|
    t.integer  "joke_id"
    t.text     "punchline"
    t.integer  "user_id"
    t.integer  "up_votes",    :default => 0
    t.integer  "down_votes",  :default => 0
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.boolean  "is_kid_safe"
    t.boolean  "spam"
  end

  add_index "alternate_punchlines", ["down_votes"], :name => "index_alternate_punchlines_on_down_votes"
  add_index "alternate_punchlines", ["joke_id"], :name => "index_alternate_punchlines_on_joke_id"
  add_index "alternate_punchlines", ["up_votes"], :name => "index_alternate_punchlines_on_up_votes"
  add_index "alternate_punchlines", ["user_id"], :name => "index_alternate_punchlines_on_user_id"

  create_table "daily_words", :force => true do |t|
    t.string   "word"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "favorite_jokes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "joke_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "favorite_jokes", ["joke_id"], :name => "index_favorite_jokes_on_joke_id"
  add_index "favorite_jokes", ["user_id"], :name => "index_favorite_jokes_on_user_id"

  create_table "jokes", :force => true do |t|
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "question"
    t.string   "answer"
    t.integer  "user_id"
    t.integer  "up_votes",                   :default => 0, :null => false
    t.integer  "down_votes",                 :default => 0, :null => false
    t.string   "jokeler_url"
    t.string   "bitly_url"
    t.integer  "alternate_punchlines_count", :default => 0, :null => false
    t.integer  "favorite_jokes_count",       :default => 0, :null => false
    t.boolean  "is_kid_safe"
    t.integer  "hit_counter",                :default => 0, :null => false
    t.string   "slug",                                      :null => false
    t.boolean  "spam"
  end

  add_index "jokes", ["down_votes"], :name => "index_jokes_on_down_votes"
  add_index "jokes", ["slug"], :name => "index_jokes_on_slug", :unique => true
  add_index "jokes", ["up_votes"], :name => "index_jokes_on_up_votes"
  add_index "jokes", ["user_id"], :name => "index_jokes_on_user_id"

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "subscribable_id"
    t.string   "subscribable_type"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "uid"
    t.string   "name"
    t.string   "provider"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.string   "image_url"
    t.string   "url"
    t.integer  "up_votes",                   :default => 0,     :null => false
    t.integer  "down_votes",                 :default => 0,     :null => false
    t.string   "token"
    t.string   "secret"
    t.integer  "alternate_punchlines_count", :default => 0,     :null => false
    t.integer  "favorite_jokes_count",       :default => 0,     :null => false
    t.integer  "jokes_count",                :default => 0,     :null => false
    t.boolean  "is_admin"
    t.boolean  "hide_avatar",                :default => false
    t.boolean  "hide_url",                   :default => false
    t.string   "display_name"
  end

  add_index "users", ["uid"], :name => "index_users_on_uid"

  create_table "votings", :force => true do |t|
    t.string   "voteable_type"
    t.integer  "voteable_id"
    t.string   "voter_type"
    t.integer  "voter_id"
    t.boolean  "up_vote",       :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "votings", ["voteable_type", "voteable_id", "voter_type", "voter_id"], :name => "unique_voters", :unique => true
  add_index "votings", ["voteable_type", "voteable_id"], :name => "index_votings_on_voteable_type_and_voteable_id"
  add_index "votings", ["voter_type", "voter_id"], :name => "index_votings_on_voter_type_and_voter_id"

end
