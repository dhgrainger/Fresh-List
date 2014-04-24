require 'spec_helper'

feature "Once recipes have been searched a user can associate them wiht themselves", %q{
  Once I've seen some meals I want to be able to save which ones I like
  so I can see ingredients
} do

  context "Can search for meals" do
    it 'enters a search query' do
      user = FactoryGirl.build(:user)

      sign_in_as(user)


      fill_in 'Name', with: 'chicken picatta, eggs, bacon'
      click_on('search')

      find(:css, "#review_ids_").set(true)

    end
  end
end

