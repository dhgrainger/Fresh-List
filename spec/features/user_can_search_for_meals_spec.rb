require 'spec_helper'

feature "User edit their account", %q{
  +I want to be able to see a list of meals that will help me meet my goals
  so that i can have fresh ideas on what to eat.
} do

  context "Can search for meals" do
    it 'enters a search query' do
      visit '/recipes/index'

      fill_in 'Search', with: 'chicken'

      expect(page).to have_css 'li'

    end
  end
end
