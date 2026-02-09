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

if Rails.env.development?
  load(Rails.root.join("db/seeds/01_admins.rb"))
  load(Rails.root.join("db/seeds/02_users.rb"))
  load(Rails.root.join("db/seeds/03_user_settings.rb"))
  load(Rails.root.join("db/seeds/04_lists.rb"))
elsif ENV["DEMO_SEED"] == "true"
  load(Rails.root.join("db/seeds/10_presentation_demo.rb"))
else
  puts "No default seeds for #{Rails.env}."
  puts "To create presentation demo data manually, run with DEMO_SEED=true."
end
