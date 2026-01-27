require "rails_helper"

RSpec.describe "Lists", type: :request do
  fixtures :users, :lists

  let(:user) { users(:one) }
  let(:list) { lists(:one) }

  before do
    user.create_user_setting!(
      default_date_range_list_display: "7",
      default_currency: "USD",
      notification_lead_time: 3
    ) unless user.user_setting

    sign_in user
  end

  it "gets index" do
    get lists_url
    expect(response).to have_http_status(:ok)
  end

  it "gets new" do
    get new_list_url
    expect(response).to have_http_status(:ok)
  end

  it "creates a list" do
    expect do
      post lists_url, params: {
        list: {
          name: "My test list",
          price: 123.45
        }
      }
    end.to change(List, :count).by(1)

    expect(response).to redirect_to(list_url(List.last))
  end

  it "shows a list" do
    get list_url(list)
    expect(response).to have_http_status(:ok)
  end

  it "gets edit" do
    get edit_list_url(list)
    expect(response).to have_http_status(:ok)
  end

  it "updates a list" do
    patch list_url(list), params: { list: { name: "Updated name" } }
    expect(response).to redirect_to(list_url(list))
  end

  it "destroys a list" do
    expect do
      delete list_url(list)
    end.to change(List, :count).by(-1)

    expect(response).to redirect_to(lists_url)
  end
end
