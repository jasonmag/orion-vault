require "rails_helper"

RSpec.describe "Insights", type: :request do
  let!(:user) do
    User.create!(
      email: "insights@example.com",
      password: "password123456",
      password_confirmation: "password123456"
    )
  end

  before do
    user_setting = user.create_user_setting!(
      default_date_range_list_display: "7",
      default_currency: "USD",
      notification_lead_time: 3
    )

    card_type = user_setting.credit_card_types.create!(
      bank_name: "Test Bank",
      last4: "4242"
    )

    user.expenses.create!(
      name: "Card expense",
      amount: 120,
      paid_at: Date.current,
      payment_method: "card",
      credit_card_type: card_type,
      source: Expense::SOURCE_MANUAL
    )

    user.expenses.create!(
      name: "Cash in",
      amount: 250,
      paid_at: Date.current,
      payment_method: "cash_in",
      source: Expense::SOURCE_MANUAL
    )

    sign_in user
  end

  it "renders the insights dashboard" do
    get insights_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Insights")
    expect(response.body).to include("Monthly cashflow comparison")
    expect(response.body).to include("Total Spend")
    expect(response.body).to include("Card Payments")
  end
end
