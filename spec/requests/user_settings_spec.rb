require 'rails_helper'

RSpec.describe "UserSettings", type: :request do
  let!(:user) { User.create!(email: "user@example.com", password: "password123", password_confirmation: "password123") }

  before { sign_in user, scope: :user }

  describe "GET /user_setting" do
    it "renders the settings form" do
      get user_setting_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Settings")
    end
  end

  describe "POST /user_setting" do
    it "updates the settings" do
      post user_setting_path, params: { user_setting: { default_currency: "EUR", notification_lead_time: 5, default_date_range_list_display: 10 } }
      expect(response).to redirect_to(user_setting_path)
      expect(user.reload.user_setting.default_currency).to eq("EUR")
      expect(user.user_setting.notification_lead_time).to eq(5)
      expect(user.user_setting.default_date_range_list_display).to eq("10")
    end
  end
end
