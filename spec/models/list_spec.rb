# spec/models/list_spec.rb
require 'rails_helper'

RSpec.describe List, type: :model do
  context 'when creating a new list' do
    it 'sets the effective_start_date to today if no date is provided' do
      list = List.create(name: "Test List", price: 99.99, description: "A test list", due_date: Date.today)

      expect(list.effective_start_date).to eq(Date.today)
    end

    it 'does not override the effective_start_date if a date is provided' do
      custom_date = Date.new(2024, 1, 1)
      list = List.create(name: "Test List", price: 99.99, description: "A test list", due_date: Date.today, effective_start_date: custom_date)

      expect(list.effective_start_date).to eq(custom_date)
    end
  end
end
