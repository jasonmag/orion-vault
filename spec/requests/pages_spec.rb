require "rails_helper"

RSpec.describe "Pages", type: :request do
  it "renders the about page" do
    get about_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("About NexDue")
    expect(response.body).to include("Tracking that feels effortless")
  end
end
