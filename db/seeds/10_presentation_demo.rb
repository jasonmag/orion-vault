puts "Seeding presentation demo data..."

demo_password = ENV.fetch("DEMO_SEED_PASSWORD", "DemoPassword123!")
today = Date.current

demo_users = [
  { email: "demo.founder@orionvault.app" },
  { email: "demo.finance@orionvault.app" }
]

list_templates = [
  {
    name: "Office Rent",
    price: 3200.00,
    description: "Main office lease",
    start_date: today - 8.months,
    end_date: today + 18.months,
    schedule: { frequency: PaymentSchedule::FREQUENCY_MONTHLY, day_of_month: 1, notification_lead_time: 5 }
  },
  {
    name: "Cloud Hosting",
    price: 420.00,
    description: "Infrastructure monthly invoice",
    start_date: today - 5.months,
    end_date: today + 18.months,
    schedule: { frequency: PaymentSchedule::FREQUENCY_MONTHLY, day_of_month: 12, notification_lead_time: 3 }
  },
  {
    name: "Payroll",
    price: 6800.00,
    description: "Team payroll",
    start_date: today - 4.months,
    end_date: today + 18.months,
    schedule: { frequency: PaymentSchedule::FREQUENCY_SEMI_MONTHLY, day_of_month: 1, notification_lead_time: 2 }
  },
  {
    name: "Internet Service",
    price: 145.00,
    description: "Business internet subscription",
    start_date: today - 7.months,
    end_date: today + 18.months,
    schedule: { frequency: PaymentSchedule::FREQUENCY_MONTHLY, day_of_month: 20, notification_lead_time: 2 }
  },
  {
    name: "CRM License",
    price: 899.00,
    description: "Annual CRM renewal",
    start_date: today - 1.year,
    end_date: today + 2.years,
    schedule: { frequency: PaymentSchedule::FREQUENCY_YEARLY, month_of_year: today.month, day_of_month: [today.day, 28].min, notification_lead_time: 14 }
  },
  {
    name: "Domain Renewal",
    price: 35.00,
    description: "Annual domain renewal",
    start_date: today - 10.months,
    end_date: today + 2.years,
    schedule: { frequency: PaymentSchedule::FREQUENCY_YEARLY, month_of_year: (today.month % 12) + 1, day_of_month: 10, notification_lead_time: 10 }
  }
]

demo_users.each do |attrs|
  user = User.find_or_initialize_by(email: attrs[:email])
  user.password = demo_password if user.new_record? || ENV["RESET_DEMO_PASSWORDS"] == "true"
  user.password_confirmation = demo_password if user.new_record? || ENV["RESET_DEMO_PASSWORDS"] == "true"
  user.save!

  setting = user.user_setting || user.build_user_setting
  setting.default_date_range_list_display = "14"
  setting.default_currency = "USD"
  setting.notification_lead_time = 3
  setting.save!

  [
    [ "Chase Business", "4242" ],
    [ "Amex Business", "0005" ]
  ].each do |bank_name, last4|
    CreditCardType.find_or_create_by!(user_setting: setting, bank_name: bank_name, last4: last4)
  end

  seeded_lists = list_templates.map do |template|
    list = user.list.find_or_initialize_by(name: template[:name])
    list.assign_attributes(
      price: template[:price],
      description: template[:description],
      effective_start_date: template[:start_date],
      effective_end_date: template[:end_date]
    )
    list.save!

    schedule = list.payment_schedule || list.build_payment_schedule
    schedule.assign_attributes(template[:schedule])
    schedule.save!
    list
  end

  month_start = today.beginning_of_month
  month_end = today.end_of_month
  due_entries = seeded_lists.flat_map do |list|
    list.due_dates_within_range(month_start, month_end).map { |due_date| [ list, due_date ] }
  end.sort_by { |list, due_date| [ due_date, list.name ] }

  due_entries.first(3).each do |list, due_date|
    history = CheckListHistory.find_or_initialize_by(user: user, list: list, due_date: due_date)
    history.checked = true
    history.checked_at ||= Time.current
    history.save!

    expense = Expense.find_or_initialize_by(user: user, list: list, due_date: due_date, source: Expense::SOURCE_DUE)
    expense.assign_attributes(
      name: list.name,
      amount: list.price,
      paid_at: Date.current,
      payment_method: "cash",
      credit_card_type: nil
    )
    expense.save!
  end
end

puts "Presentation demo data ready."
puts "Demo users:"
demo_users.each { |u| puts "  - #{u[:email]} / #{demo_password}" }
