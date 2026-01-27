require 'rails_helper'

RSpec.describe "Date range calendar", type: :system, js: true do
  let(:user) do
    User.create!(
      email: "calendar@example.com",
      password: "password123456",
      password_confirmation: "password123456"
    )
  end

  if ENV["RUN_SYSTEM_SPECS"] == "1"
    it "sets a start and end date and highlights the range" do
      travel_to(Date.new(2026, 1, 15)) do
        login_as(user, scope: :user)

        visit lists_path
        find("summary").click

        find("button[data-date='2026-01-10']").click
        find("button[data-date='2026-01-14']").click

        expect(find("input[name='start_date']", visible: false).value).to eq("2026-01-10")
        expect(find("input[name='end_date']", visible: false).value).to eq("2026-01-14")

        expect(find("button[data-date='2026-01-10']")[:class]).to include("bg-white")
        expect(find("button[data-date='2026-01-12']")[:class]).to include("bg-slate-700")
        expect(find("button[data-date='2026-01-14']")[:class]).to include("bg-white")
      end
    end
  end
end
