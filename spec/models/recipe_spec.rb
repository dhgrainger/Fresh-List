require 'spec_helper'

describe Recipe do
  it {should validate_presence_of(:name)}
  it {should validate_uniqueness_of(:name)}
  it {should validate_presence_of(:image)}
  it {should validate_presence_of(:carbs)}
  it {should validate_presence_of(:protein)}
  it {should validate_presence_of(:fats)}
  it {should validate_presence_of(:url)}
  it { should have_many(:user_recipes) }
end
