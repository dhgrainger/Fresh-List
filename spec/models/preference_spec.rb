require 'spec_helper'

describe Preference do
  it { should belong_to(:user) }
end
