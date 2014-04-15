require 'spec_helper'

feature "User edit their account", %q{
  As a shopper
  I want to be able to edit my profile name, my goals, activity levels, age, and weight.
} do


  context "with valid attributes" do
    it "creates a user with valid attributes" do

      user = FactoryGirl.build(:user)

      visit 'users/sign_up'

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

      expect(User.first.username).to eql(user.username)
      expect(User.first.weight).to eql(user.weight)
      expect(User.first.activity).to eql(user.activity)
      expect(User.first.goal).to eql(user.goal)

      click_on "Edit"

      fill_in "Username", with: "Username"
      select 200, from: "Weight"
      select "Sedentary", from: "Activity"
      select "Maintain", from: "Goal"

      click_on "Edit"

      expect(User.first.username).to_not eql(user.username)
      expect(User.first.weight).to_not eql(user.weight)
      expect(User.first.activity).to_not eql(user.activity)
      expect(User.first.goal).to_not eql(user.goal)

    end
  end
end
