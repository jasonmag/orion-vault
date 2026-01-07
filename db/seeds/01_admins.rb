puts "Seeding Admins..."

admin = Admin.find_or_initialize_by(email: "admin@example.com")
admin.password = "password12345"
admin.password_confirmation = "password12345"
admin.save!
