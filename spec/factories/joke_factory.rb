FactoryGirl.define do
  factory :joke do
    question 'What is a joke?'
    answer 'This!'
    is_kid_safe true
  end

  factory :dirty_joke, parent: :joke do
    is_kid_safe false
  end

  factory :joke_with_user, parent: :joke do
    user
  end
end
