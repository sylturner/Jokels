require 'rufus/scheduler'
require 'rss/2.0'


scheduler = Rufus::Scheduler.start_new

# every day at 10:00am
scheduler.cron '00 10 * * 0-6 America/New_York' do
   	# set random word of the day
   	File.open('wordlist.txt') do |f|
      l = f.readlines
      DailyWord.new(:word => l[rand(l.size)].chomp).save!
    end
    
    # scan the jokeler's RSS for new jokeler posts and associate them with jokes
    source= "http://jokeler.tumblr.com/rss"
    content = ""
    open(source) do |s| content = s.read end
    rss = RSS::Parser.parse(content, false)
    rss = rss.items.delete_if{|x| !x.title.starts_with? "http://"}
    rss.each do |x| 
      id = x.title.split('/').last
      joke = Joke.find(id)
      if !joke.jokeler_url
        joke.jokeler_url = x.link      
        joke.save!
      end
    end
end