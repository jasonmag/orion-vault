require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  it "inherits from ApplicationMailer" do
    expect(described_class).to be < ApplicationMailer
  end
end
