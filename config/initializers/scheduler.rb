require 'rufus/scheduler'


scheduler = Rufus::Scheduler.start_new

scheduler.every("1d") do
   	File.open('wordlist.txt') do |f|
      l = f.readlines
      DailyWord.new(:word => l[rand(l.size)].chomp).save!
    end
end