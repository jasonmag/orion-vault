module DueDateable
  extend ActiveSupport::Concern

  included do
    def due_dates_within_range(start_date, end_date)
      return [] unless payment_schedule

      case payment_schedule.frequency
      when PaymentSchedule::FREQUENCY_MONTHLY
        calculate_monthly_due_dates(start_date, end_date)
      when PaymentSchedule::FREQUENCY_WEEKLY
        calculate_weekly_due_dates(start_date, end_date)
      when PaymentSchedule::FREQUENCY_BI_WEEKLY
        calculate_bi_weekly_due_dates(start_date, end_date)
      when PaymentSchedule::FREQUENCY_YEARLY
        calculate_yearly_due_dates(start_date, end_date)
      when PaymentSchedule::FREQUENCY_ONCE
        calculate_once_due_date(start_date, end_date)
      else
        []
      end
    end

    private

    # Monthly due dates within the given range
    def calculate_monthly_due_dates(start_date, end_date)
      due_dates = []
      current_date = effective_start_date || Date.today
      day_of_month = payment_schedule.day_of_month || 1

      while current_date <= end_date
        next_due = Date.new(current_date.year, current_date.month, [day_of_month, Date.civil(current_date.year, current_date.month, -1).day].min)
        due_dates << next_due if next_due.between?(start_date, end_date)
        current_date = current_date.next_month
      end

      due_dates
    end

    # Weekly due dates within the given range
    def calculate_weekly_due_dates(start_date, end_date)
      due_dates = []
      current_date = effective_start_date || Date.today
      day_of_week = payment_schedule.day_of_week || 1

      while current_date <= end_date
        next_due = current_date + (day_of_week - current_date.wday) % 7
        due_dates << next_due if next_due.between?(start_date, end_date)
        current_date += 1.week
      end

      due_dates
    end

    # Bi-weekly due dates within the given range
    def calculate_bi_weekly_due_dates(start_date, end_date)
      due_dates = []
      current_date = effective_start_date || Date.today
      day_of_week = payment_schedule.day_of_week || 1

      while current_date <= end_date
        next_due = current_date + (day_of_week - current_date.wday) % 7
        due_dates << next_due if next_due.between?(start_date, end_date)
        current_date += 2.weeks
      end

      due_dates
    end

    # Yearly due dates within the given range
    def calculate_yearly_due_dates(start_date, end_date)
      due_dates = []
      current_year = Date.today.year
      month_of_year = payment_schedule.month_of_year || 1
      due_date = Date.new(current_year, month_of_year, payment_schedule.day_of_month || 1)

      if due_date.between?(start_date, end_date)
        due_dates << due_date
      end

      due_dates
    end

    # Once due date within the given range
    def calculate_once_due_date(start_date, end_date)
      due_date = effective_start_date
      due_date && due_date.between?(start_date, end_date) ? [due_date] : []
    end
  end
end
