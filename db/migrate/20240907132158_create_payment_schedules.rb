class CreatePaymentSchedules < ActiveRecord::Migration[7.2]
  def change
    create_table :payment_schedules do |t|
      t.references :list, null: false, foreign_key: true
      t.string :frequency, null: false # e.g., "monthly", "weekly", "bi-weekly", "yearly"
      t.integer :day_of_month # For monthly and yearly payments (which day of the month, e.g., 15 for the 15th)
      t.integer :day_of_week # For weekly and bi-weekly payments (which day of the week, e.g., 1 for Monday)
      t.integer :month_of_year # For yearly payments (which month, e.g., 1 for January)
      t.integer :notification_lead_time, null: false # e.g., 5, 15, or 30 days before the due date

      t.timestamps
    end
  end
end
