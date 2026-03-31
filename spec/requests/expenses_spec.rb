require "rails_helper"

RSpec.describe "Expenses", type: :request do
  let!(:user) do
    User.create!(
      email: "expenses@example.com",
      password: "password123456",
      password_confirmation: "password123456"
    )
  end

  before do
    user.create_user_setting!(
      default_date_range_list_display: "7",
      default_currency: "USD",
      notification_lead_time: 3
    )

    12.times do |index|
      user.expenses.create!(
        name: "Expense #{index + 1}",
        amount: index + 1,
        paid_at: Date.new(2026, 3, 31) - index.days,
        payment_method: "cash",
        source: Expense::SOURCE_MANUAL
      )
    end

    sign_in user
  end

  it "renders the default page size" do
    get expenses_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Expense 1")
    expect(response.body).to include("Expense 10")
    expect(response.body).not_to include("Expense 11")
    expect(response.body).to include('option selected="selected" value="10"')
  end

  it "uses the requested page size" do
    get expenses_path, params: { per_page: 25 }

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Expense 11")
    expect(response.body).to include("Expense 12")
    expect(response.body).to include('option selected="selected" value="25"')
  end
end
