require 'spec_helper'

describe UserRecipe do
  it { should belong_to(:user) }
  it { should belong_to(:recipe) }
end
