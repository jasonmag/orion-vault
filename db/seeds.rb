# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Optional: clean database before seeding
puts "Clearing old data..."
CheckListHistory.delete_all
PaymentSchedule.delete_all
List.delete_all
UserSetting.delete_all
User.delete_all
Admin.delete_all

# Load seeds
Dir[Rails.root.join('db/seeds/*.rb')].sort.each { |file| load file }

puts "Done seeding!"