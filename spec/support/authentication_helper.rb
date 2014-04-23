module AuthenticationHelper
  def sign_in_as(user)

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
  end
end

