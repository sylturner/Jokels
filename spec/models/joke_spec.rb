require 'spec_helper'

describe Joke do
  it { should have_many(:favorite_jokes).dependent(:destroy) }
  it { should have_many(:alternate_punchlines).dependent(:destroy) }

  it { should belong_to(:user) }

  describe "spam_check" do
    it "should be invalid if it's spammy" do
      joke = Joke.new
      joke.question = "viagra gambling shemale ringtones poker valeofglamorganconservatives booker"
      joke.answer = "viagra gambling shemale ringtones poker valeofglamorganconservatives booker"
      joke.valid?.should be_false
    end

    it "should be invalid if it only has one word in the question" do
      joke = Joke.new
      joke.question = "xJk8d"
      joke.answer = "tYn0j"
      joke.valid?.should be_false
    end

    it "should be valid if it looks enough like a joke" do
      joke = Joke.new
      joke.question = "Why did the horse eat a fish?"
      joke.answer = "It was hungry"
      joke.valid?.should be_true
    end

  end

  describe "#should_generate_friendly_id?" do
    it "should generate a friendly id when the joke is new and doesn't have a slug" do
      joke = FactoryGirl.build(:joke)
      joke.should_generate_new_friendly_id?.should be_true
    end
    it "should not generate a friendly id when the joke isn't new" do
      joke = FactoryGirl.create(:joke)
      joke.should_generate_new_friendly_id?.should be_false
    end
    it "should not generate a friendly id when the joke already has a slug" do
      joke = FactoryGirl.create(:joke, slug: "what-is-a-joke")
      joke.should_generate_new_friendly_id?.should be_false
    end
  end

  describe "#forks_count" do
    let(:joke) { FactoryGirl.create(:joke) }
    before do
      joke.alternate_punchlines = [FactoryGirl.build(:alternate_punchline), FactoryGirl.build(:dirty_fork)]
      joke.save
      joke.reload
    end

    it "should count all forks in normal/dirty mode" do
      joke.forks_count.should == 2
    end
    it "should only count clean forks in clean mode" do
      joke.forks_count(true).should == 1
    end
  end

  describe "#generate_bitly_url" do
    it "should generate a bitly url after create" do
      joke = FactoryGirl.build(:joke)
      joke.should_receive(:generate_bitly_url)
      joke.save
    end
  end

  describe "is_profane?" do
    it "should be true if a bad word is in the question" do
      joke = FactoryGirl.build(:joke, question: "What is shit?")
      joke.is_profane?.should be_true
    end

    it "should be true if a bad word is in the answer" do
      joke = FactoryGirl.build(:joke, answer: "Awww shit!")
      joke.is_profane?.should be_true
    end

    it "should be false if there are no bad words is in the question" do
      joke = FactoryGirl.build(:joke, question: "What is sheeeit?")
      joke.is_profane?.should be_false
    end

    it "should be false if there are no bad words is in the answer" do
      joke = FactoryGirl.build(:joke, answer: "Aww sheeeit!")
      joke.is_profane?.should be_false
    end
  end

  describe "#post_top_jokes" do
    it "should post the top joke of the day" do
      now = Time.now
      top_joke = FactoryGirl.create(:joke, up_votes: 3, down_votes: 0, created_at: now-1.day)
      not_top_joke = FactoryGirl.create(:joke, up_votes: 0, down_votes: 1, created_at: now-1.day)

      Joke.stub(:post_top_joke).and_return(true)
      Joke.should_receive(:post_top_joke).with(top_joke, "#{(now-1.day).strftime("%b %d")} top joke")
      Joke.post_top_jokes
    end

    it "should post the top joke of the week at the beginning of the week" do
      last_week = 1.week.ago
      top_joke = FactoryGirl.create(:joke, up_votes: 3, down_votes: 0, created_at: last_week)
      not_top_joke = FactoryGirl.create(:joke, up_votes: 0, down_votes: 1, created_at: last_week)

      Timecop.travel(Date.today.beginning_of_week)
      Joke.stub(:post_top_joke).and_return(true)
      Joke.should_receive(:post_top_joke).with(top_joke, "Week of #{(Date.today-1.day).beginning_of_week.strftime("%B %d")} - #{(Date.today-1.day).strftime("%B %d")} top joke")
      Joke.post_top_jokes
      Timecop.return
    end

    it "should post the top joke of the month at the beginning of the month" do
      last_month = 1.month.ago
      top_joke = FactoryGirl.create(:joke, up_votes: 3, down_votes: 0, created_at: last_month)
      not_top_joke = FactoryGirl.create(:joke, up_votes: 0, down_votes: 1, created_at: last_month)

      Timecop.travel(Date.today.beginning_of_month)
      Joke.stub(:post_top_joke).and_return(true)
      Joke.should_receive(:post_top_joke).with(top_joke, "#{(Time.now-1.day).strftime("%B %Y")} top joke")
      Joke.post_top_jokes
      Timecop.return
    end

    it "should post the top joke of the year at the beginning of the year" do
      last_year = 1.year.ago
      top_joke = FactoryGirl.create(:joke, up_votes: 3, down_votes: 0, created_at: last_year)
      not_top_joke = FactoryGirl.create(:joke, up_votes: 0, down_votes: 1, created_at: last_year)

      Timecop.travel(Date.today.beginning_of_year)
      Joke.stub(:post_top_joke).and_return(true)
      Joke.should_receive(:post_top_joke).with(top_joke, "Happy New Year - Top joke for #{(Time.now-1.day).strftime("%Y")}")
      Joke.post_top_jokes
      Timecop.return
    end
  end

  describe "#random_joke" do
    let(:joke) { FactoryGirl.create(:joke) }
    let(:dirty_joke) { FactoryGirl.create(:dirty_joke) }
    let(:crappy_joke) { FactoryGirl.create(:joke, down_votes: 4, up_votes: 0) }
    it "should return a random joke" do
      [joke, dirty_joke].include?(Joke.random_joke).should == true
    end
    it "should return a random joke with a vote threshold greater than -2" do
      [joke, dirty_joke].include?(Joke.random_joke).should == true
    end
    it "should only return a random kid safe joke" do
      [joke].include?(Joke.random_joke(true)).should == true
    end
  end
end
