require 'rails_helper'

RSpec.describe PaymentSchedule, type: :model do
  fixtures :users, :lists

  it "is valid with a monthly frequency and day_of_month" do
    schedule = described_class.new(
      list: lists(:one),
      frequency: PaymentSchedule::FREQUENCY_MONTHLY,
      day_of_month: 5,
      notification_lead_time: 3
    )

    expect(schedule).to be_valid
  end

  it "rejects invalid frequency values" do
    schedule = described_class.new(
      list: lists(:one),
      frequency: "daily",
      notification_lead_time: 3
    )

    expect(schedule).not_to be_valid
    expect(schedule.errors[:frequency]).to be_present
  end

  it "requires day_of_month for semi-monthly schedules" do
    schedule = described_class.new(
      list: lists(:one),
      frequency: PaymentSchedule::FREQUENCY_SEMI_MONTHLY,
      notification_lead_time: 3
    )

    expect(schedule).not_to be_valid
    expect(schedule.errors[:day_of_month]).to be_present
  end
end
