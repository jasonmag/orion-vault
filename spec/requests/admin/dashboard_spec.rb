require 'rails_helper'

RSpec.describe "Admin::Dashboard", type: :request do
  let!(:admin) { Admin.create!(email: "admin@example.com", password: "password123", password_confirmation: "password123") }
  let!(:user) { User.create!(email: "user@example.com", password: "password123", password_confirmation: "password123") }
  let!(:list) { user.list.create!(name: "Water Bill", price: 12.50, effective_start_date: Date.current) }
  let!(:payment_schedule) do
    PaymentSchedule.create!(
      list: list,
      frequency: PaymentSchedule::FREQUENCY_MONTHLY,
      day_of_month: 1,
      notification_lead_time: 3
    )
  end
  let!(:activity) { CheckListHistory.create!(user: user, list: list, due_date: Date.current, checked: true, checked_at: Time.current) }

  describe "GET /admin/dashboard" do
    it "redirects unauthenticated visitors" do
      get admin_dashboard_path
      expect(response).to redirect_to(new_admin_session_path)
    end

    it "shows metrics and recent activity for signed in admins" do
      sign_in admin

      get admin_dashboard_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Admin Dashboard")
      expect(response.body).to include("Users")
      expect(response.body).to include(user.email)
      expect(response.body).to include(list.name)
    end

    it "exports list data as CSV" do
      sign_in admin

      get admin_dashboard_path(format: :csv)

      expect(response.headers["Content-Type"]).to include("text/csv")
      expect(response.body).to include(list.name)
      expect(response.body).to include(user.email)
    end
  end
end
