class InsightsController < ApplicationController
  before_action :authenticate_user!

  def index
    today = Date.current
    months_back = 5
    start_month = (today - months_back.months).beginning_of_month
    end_month = today.end_of_month

    expenses = current_user.expenses.where(paid_at: start_month..end_month)
    monthly_totals = {}

    expenses.each do |expense|
      month_key = expense.paid_at.beginning_of_month
      monthly_totals[month_key] ||= { due: 0.to_d, manual: 0.to_d }
      if expense.source == Expense::SOURCE_DUE
        monthly_totals[month_key][:due] += expense.amount
      else
        monthly_totals[month_key][:manual] += expense.amount
      end
    end

    @monthly_rows = (0..months_back).map do |offset|
      month_start = (today - (months_back - offset).months).beginning_of_month
      totals = monthly_totals[month_start] || { due: 0.to_d, manual: 0.to_d }
      total = totals[:due] + totals[:manual]
      {
        month: month_start.strftime("%b %Y"),
        due: totals[:due],
        manual: totals[:manual],
        total: total
      }
    end

    @max_total = @monthly_rows.map { |row| row[:total] }.max || 0.to_d
    @total_spend = @monthly_rows.sum { |row| row[:total] }
    @due_spend = @monthly_rows.sum { |row| row[:due] }
    @manual_spend = @monthly_rows.sum { |row| row[:manual] }
  end
end
