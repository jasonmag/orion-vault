require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the UserSettingsHelper. For example:
#
# describe UserSettingsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe UserSettingsHelper, type: :helper do
  it "is included in the helper context" do
    expect(helper.class.included_modules).to include(UserSettingsHelper)
  end
end
