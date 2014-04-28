require 'spec_helper'

describe UserRecipe do
  it { should belong_to(:user) }
  it { should belong_to(:recipe) }
  it { should validate_uniqueness_of(:user_id).scoped_to(:recipe_id)}
end
