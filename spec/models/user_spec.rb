require 'spec_helper'

describe User do

  before(:each) do
    FactoryGirl.create(:user)
  end

  it {should validate_presence_of(:username)}
  it {should validate_uniqueness_of(:username)}
  it {should validate_presence_of(:gender)}
  it {should validate_presence_of(:weight)}
  it {should validate_presence_of(:height)}
  it {should validate_presence_of(:activity)}
  it {should validate_presence_of(:goal)}
  it {should validate_presence_of(:age)}
  it { should have_many(:preferences) }
  it { should have_many(:user_recipes) }
end
