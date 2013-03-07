# -*- encoding : utf-8 -*-
class DailyWord < ActiveRecord::Base

  def self.set_daily_word
    # set random word of the day
   	File.open('wordlist.txt') do |f|
      l = f.readlines
      word = l[rand(l.size)].chomp

      # don't do the same word two days in a row
      while word == DailyWord.last.word do
        word = l[rand(l.size)].chomp
      end
      DailyWord.new(:word => word).save!
    end
    # and tweet it
    jokels_user = User.find 1 # @jokelscom
    client = Twitter::Client.new(:oauth_token => jokels_user.token, :oauth_token_secret => jokels_user.secret)
    post = "Today's inspiration: \"#{DailyWord.last.word}\" - http://jokels.com"
    client.update(post)

    settings = YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env]
    FGraph.publish_feed('me', :message => post, :access_token => settings["facebook"]["page_access_token"])
  end
end
