require 'spec_helper'

feature "User creates an account", %q{
  As a shopper
  I want to set up a username and password
  as well as enter my height, weight, gender
  age activity levels, and weight loss/gain goals
  so that i can see which levels of macronutrients I should be consuming.
} do

  before(:each) do
    visit '/users/sign_up'
  end

  context "with valid attributes" do
    it "creates a user with valid attributes" do

      user = FactoryGirl.build(:user)

      fill_in "Email", with: user.email
      fill_in "user_password", with: user.password
      fill_in "user_password_confirmation", with: user.password
      fill_in "Username", with: user.username
      choose user.gender
      select user.height, from: "Height"
      select user.weight, from: "Weight"
      select user.activity, from: "Activity"
      select user.age, from: "Age"
      select user.goal, from: "Goal"

      click_on "Calculate"

      expect(page).to have_content(user.username)
      expect(page).to have_content(user.age)
      expect(page).to have_content(user.gender)
      expect(page).to have_content(user.height)
      expect(page).to have_content(user.weight)
      expect(page).to have_content(user.activity)
      expect(page).to have_content(user.goal)
    end
  end

  context 'user signs up with invalid attributes' do
    it 'requires a user to enter their information' do

      click_on "Calculate"
      expect(page).to have_content("Usernamecan't be blank")
      expect(page).to have_content("Emailcan't be blank")
      expect(page).to have_content("Passwordcan't be blank")
      expect(page).to have_content("Activecan't be blank")
    end
  end

  context 'user can see their daily recommended caloric intakes' do
    it 'shows carbohydrate values in grams and calories' do

      user = FactoryGirl.build(:user)

      fill_in "Email", with: user.email
      fill_in "user_password", with: user.password
      fill_in "user_password_confirmation", with: user.password
      fill_in "Username", with: user.username
      choose user.gender
      select user.height, from: "Height"
      select user.weight, from: "Weight"
      select user.activity, from: "Activity"
      select user.age, from: "Age"
      select user.goal, from: "Goal"

      click_on "Calculate"

      expect(page).to have_content(user.carbcals)
      expect(page).to have_content(user.carbgrams)
      expect(page).to have_content(user.proteincals)
      expect(page).to have_content(user.proteingrams)
      expect(page).to have_content(user.fatcals)
      expect(page).to have_content(user.fatgrams)

    end
  end
end
