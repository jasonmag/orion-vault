class AddDayOfMonthSecondToPaymentSchedules < ActiveRecord::Migration[8.0]
  def change
    add_column :payment_schedules, :day_of_month_second, :integer
  end
end
