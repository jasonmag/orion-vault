require 'rails_helper'

RSpec.describe CheckListHistory, type: :model do
  fixtures :users, :lists

  it "is valid with a user, list, and due_date" do
    record = described_class.new(
      user: users(:one),
      list: lists(:one),
      due_date: Date.current
    )

    expect(record).to be_valid
  end

  it "requires a due_date" do
    record = described_class.new(
      user: users(:one),
      list: lists(:one),
      due_date: nil
    )

    expect(record).not_to be_valid
    expect(record.errors[:due_date]).to be_present
  end
end
