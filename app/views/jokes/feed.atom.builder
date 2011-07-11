atom_feed do |feed|
  feed.title "Jokels"
  feed.updated @jokes.first.created_at

  @jokes.each do |joke|
    feed.entry joke do |entry|
      entry.title joke.question

      if joke.user
        entry.author do |author|
          writer = joke.user.name + " via " + joke.user.provider.capitalize
          author.name writer
        end
      end
    end
  end
end