module DueDateable
  extend ActiveSupport::Concern

  included do
    # Define a method for dynamically calculating the next due date
    def next_due_date
      return nil unless payment_schedule

      case payment_schedule.frequency
      when "monthly"
        calculate_monthly_due_date
      when "weekly"
        calculate_weekly_due_date
      when "bi-weekly"
        calculate_bi_weekly_due_date
      when "yearly"
        calculate_yearly_due_date
      else
        nil
      end
    end

    private

    def calculate_monthly_due_date
      day_of_month = payment_schedule.day_of_month || 1
      due_date = Date.today.beginning_of_month + (day_of_month - 1).days
      due_date >= Date.today ? due_date : due_date.next_month
    end

    def calculate_weekly_due_date
      day_of_week = payment_schedule.day_of_week || 0 # Assuming Sunday = 0
      today = Date.today
      due_date = today + (day_of_week - today.wday) % 7
      due_date >= today ? due_date : due_date + 1.week
    end

    def calculate_bi_weekly_due_date
      # Assume bi-weekly from the effective start date
      start_date = effective_start_date || Date.today
      days_since_start = (Date.today - start_date).to_i
      weeks_passed = days_since_start / 7
      next_due = start_date + (weeks_passed + 1).weeks * 2
      next_due
    end

    def calculate_yearly_due_date
      month_of_year = payment_schedule.month_of_year || 1
      due_date = Date.new(Date.today.year, month_of_year, payment_schedule.day_of_month || 1)
      due_date >= Date.today ? due_date : due_date.next_year
    end
  end
end
