# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "test#{n}@test.com"}
    sequence(:username) {|n| "DouglasFresh#{n}"}
    password 'password'
    password_confirmation 'password'
    gender 'Male'
    weight '220'
    height '75'
    age '26'
    activity 'Very Active'
    goal 'Lose Weight'
    bmi '25'
  end
end
