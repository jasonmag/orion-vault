require "rails_helper"

RSpec.describe "user_settings/show.html.haml", type: :view do
  it "renders the settings header and form" do
    assign(:user_setting, UserSetting.new)

    render template: "user_settings/show"

    expect(rendered).to include("Settings")
    expect(rendered).to include("Auto-save is on.")
    expect(rendered).to include("user_setting")
  end
end
