puts "🌱 Seeding User Settings..."

User.find_each do |user|
  default_days = [7, 14, 30].sample # 7 = week, 14 = fortnight, 30 = month

  UserSetting.create!(
    user_id: user.id,
    default_date_range_list_display: default_days.to_s, # stored as string
    default_currency: "USD",
    notification_lead_time: rand(1..7)
  )
end
