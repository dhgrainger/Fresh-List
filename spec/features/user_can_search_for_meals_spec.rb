require 'spec_helper'

feature "User can search on meals based on their preferences", %q{
  +I want to be able to see a list of meals that will help me meet my goals
  so that i can have fresh ideas on what to eat.
} do

  context "Can search for meals" do
    it 'enters a search query' do
      user = FactoryGirl.build(:user)

      sign_in_as(user)


      fill_in 'Enter Some food preferences', with: 'chicken picatta, eggs, bacon'
      click_on('search')

      expect(page).to have_content('Chicken Picatta')
      expect(page).to have_content('Eggs')
      expect(page).to have_content('Bacon')
    end
  end
end
