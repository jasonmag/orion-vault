puts "Seeding Lists and Payment Schedules..."

frequencies = %w[weekly bi-weekly monthly yearly once]
day_of_week_range = 0..6  # 0 = Sunday ... 6 = Saturday
day_of_month_range = 1..28
month_of_year_range = 1..12

User.find_each do |user|
  rand(10..50).times do |i|
    list = List.create!(
      user_id: user.id,
      name: Faker::Commerce.product_name,
      price: Faker::Commerce.price(range: 10..999.99),
      description: Faker::Lorem.sentence(word_count: 10),
      effective_start_date: Faker::Date.between(from: 3.months.ago, to: Date.today),
      effective_end_date: Faker::Date.between(from: Date.today + 1.month, to: Date.today + 2.years),
      created_at: Time.current,
      updated_at: Time.current
    )

    # Select frequency either randomly or cycle through to ensure all are covered
    frequency = frequencies[i % frequencies.size] # ensures all 5 get used

    payment_schedule = PaymentSchedule.new(
      list_id: list.id,
      frequency: frequency,
      notification_lead_time: rand(1..7), # in days
      created_at: Time.current,
      updated_at: Time.current
    )

    # Assign relevant attributes depending on frequency
    case frequency
    when "weekly", "bi-weekly"
      payment_schedule.day_of_week = rand(day_of_week_range)
    when "monthly"
      payment_schedule.day_of_month = rand(day_of_month_range)
    when "yearly"
      payment_schedule.day_of_month = rand(day_of_month_range)
      payment_schedule.month_of_year = rand(month_of_year_range)
    when "once"
      payment_schedule.day_of_month = list.effective_start_date.day
    end

    payment_schedule.save!
  end
end
