FactoryGirl.define do
  factory :user do
    name "Nothing User"
  end

  factory :facebook_user, parent: :user do
    name "Facebook User"
    uid "12345"
    provider "facebook"
    url "http://facebook.com/jokelscom"
    image_url "http://facebook.com/jokelscom/profile.jpg"
  end

  factory :twitter_user, parent: :user do
    name "Twitter User"
    uid "54321"
    provider "twitter"
    url "http://twitter.com/jokelscom"
    image_url "http://twitter.com/jokelscom/profile.jpg"
  end

  factory :persona_user, parent: :user do
    uid "email@address.com"
    name "Persona User"
    display_name "Persona User Display Name"
    image_url "https://secure.gravatar.com/avatar/186f43be1c959be30201e1ec6f5bed0d?d=retro"
    provider "persona"
  end

  factory :admin_user, parent: :persona_user do
    name "Admin User"
    is_admin true
  end
end
