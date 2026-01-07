puts "Seeding Users..."

3.times do
 User.create!(
    email: Faker::Internet.unique.email,
    password: "password12345",
    password_confirmation: "password12345"
  )
end
