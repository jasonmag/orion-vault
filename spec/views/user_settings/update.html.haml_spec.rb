require "rails_helper"

RSpec.describe "user_settings/show.html.haml", type: :view do
  it "renders the autosave form fields" do
    assign(:user_setting, UserSetting.new)

    render template: "user_settings/show"

    expect(rendered).to include("autosave")
    expect(rendered).to include("notification_lead_time")
  end
end
