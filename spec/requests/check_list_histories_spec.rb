require "rails_helper"

RSpec.describe "CheckListHistories", type: :request do
  fixtures :users, :lists

  let(:user) { users(:one) }
  let(:list) { lists(:one) }

  before do
    sign_in user
  end

  describe "POST /lists/:list_id/check_list_histories" do
    it "creates a checked history and expense" do
      expect do
        post list_check_list_histories_url(list), params: {
          due_date: "2026-01-10",
          checked: "true"
        }
      end.to change(CheckListHistory, :count).by(1).and change(Expense, :count).by(1)

      expect(response).to have_http_status(:ok)
    end
  end
end
