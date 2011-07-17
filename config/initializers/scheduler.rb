require 'rufus/scheduler'


scheduler = Rufus::Scheduler.start_new

scheduler.every("1d") do
   	# set random word of the day
   	File.open('wordlist.txt') do |f|
      l = f.readlines
      DailyWord.new(:word => l[rand(l.size)].chomp).save!
    end
    
    # TODO: scan the jokeler site for new jokeler posts
    
end