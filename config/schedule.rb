# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, File.join("log", "cron.log")

every 1.day, :at => "07:00am" do
  runner "DailyWord.set_daily_word" # sets the new daily word and tweets it
  runner "Joke.jokeler_update" # check the jokeler
end

every 1.day, :at => "09:00am" do
  runner "Joke.post_top_joke" #tweet yesterday's top joke
end