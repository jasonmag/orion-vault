puts "🌱 Seeding Payment Schedules..."

List.find_each do |list|
  PaymentSchedule.create!(
    list_id: list.id,
    frequency: %w[monthly weekly bi-weekly yearly once].sample,
    day_of_month: rand(1..28),
    day_of_week: rand(0..6),
    month_of_year: rand(1..12),
    notification_lead_time: rand(1..5)
  )
end
