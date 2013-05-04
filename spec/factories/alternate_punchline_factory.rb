FactoryGirl.define do
  factory :alternate_punchline do
    #association :joke, factory: :joke
    punchline 'Forked!'
    is_kid_safe true
  end

  factory :dirty_fork, parent: :alternate_punchline do
    is_kid_safe false
  end
end
