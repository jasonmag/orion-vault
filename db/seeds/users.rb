puts "🌱 Seeding Users..."

3.times do
  User.create!(
    email: Faker::Internet.unique.email,
    password: "password",
    password_confirmation: "password"
  )
end
