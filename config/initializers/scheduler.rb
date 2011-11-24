# NOT USING THIS AT THE MOMENT
# require 'rufus/scheduler'
# require 'rss/2.0'
# 
# 
# scheduler = Rufus::Scheduler.start_new
# 
# jokels_user = User.find 1
# @client = Twitter::Client.new(:oauth_token => jokels_user.token, :oauth_token_secret => jokels_user.secret)
# 
# # every day at 10:00am
# scheduler.cron '00 11 * * *' do
#     # set random word of the day
#     File.open('wordlist.txt') do |f|
#       l = f.readlines
#       DailyWord.new(:word => l[rand(l.size)].chomp).save!
#     end
#     
#     # scan the jokeler's RSS for new jokeler posts and associate them with jokes
#     source= "http://jokeler.tumblr.com/rss"
#     content = ""
#     open(source) do |s| content = s.read end
#     rss = RSS::Parser.parse(content, false)
#     rss = rss.items.delete_if{|x| !x.title.starts_with? "http://"}
#     rss.each do |x| 
#       id = x.title.split('/').last
#       joke = Joke.find(id)
#       if !joke.jokeler_url
#         joke.jokeler_url = x.link      
#         joke.save!
#       end
#     end
#     @client.update("Today's inspiration: " + DailyWord.last[:word] + " http://jokels.com")
# end

# every day at 12:00pm
#scheduler.cron '00 12 * * 0-6 America/New_York' do
#  
#  top_joke = Joke.where(['created_at BETWEEN ? AND ?', Date.yesterday, Time.now]).sort_by{|x| x.votes}.reverse[0]
#  if top_joke
#    tweet = "Yesterday's top joke: "
#    user = top_joke.user
#    if user
#      
#    end
#    client.update(@joke.question + " " + url_for(@joke))
#  end
#end