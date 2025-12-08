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

load(Rails.root.join("db/seeds/01_admins.rb")) if Rails.env.development?
load(Rails.root.join("db/seeds/02_users.rb")) if Rails.env.development?
load(Rails.root.join("db/seeds/03_user_settings.rb")) if Rails.env.development?
load(Rails.root.join("db/seeds/04_lists.rb")) if Rails.env.development?
