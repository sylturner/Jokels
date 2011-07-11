atom_feed do |feed|
  feed.title "Jokels"
  feed.updated @jokes.first.created_at

  @jokes.each do |joke|
    feed.entry joke do |entry|
      entry.title joke.question
      entry.content joke.answer
  
      entry.author do |author|
        writer = "Anonymous"
        if joke.user
          writer = joke.user.name + " via " + joke.user.provider.capitalize
        end
        author.name writer
      end
   
    end
  end
end