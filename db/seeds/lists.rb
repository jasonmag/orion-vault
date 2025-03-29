puts "🌱 Seeding Lists..."

User.find_each do |user|
  2.times do
    List.create!(
      user_id: user.id,
      name: Faker::Commerce.product_name,
      price: Faker::Commerce.price(range: 10..100),
      description: Faker::Lorem.sentence(word_count: 10),
      effective_start_date: Date.today.beginning_of_month,
      effective_end_date: Date.today.end_of_year
    )
  end
end
