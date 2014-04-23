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

  factory :recipe do
    name "chicken picatta"
    url "www.yummly.com/recipe/Chicken-Picatta-514008?"
    image "http://lh6.ggpht.com/tJo0RAwhEHOXcXFWalX6TbPQznd6DlUB21YWoCc2jFw7A30Tra5ArC2Oh0U0JL-VvQtQ9kvUf8NvDdAaXndA=s230-c"
    fats '24'
    protein '22'
    carbs '9'
  end

  factory :preference do
    name 'chicken'
    user
  end
  factory :user_recipe do
    user
    recipe
  end
end
