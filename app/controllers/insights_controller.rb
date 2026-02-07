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
      monthly_totals[month_key] ||= { cash: 0.to_d, card: 0.to_d, cash_in: 0.to_d, other: 0.to_d }

      case expense.payment_method
      when "cash_in"
        monthly_totals[month_key][:cash_in] += expense.amount
      when "cash"
        monthly_totals[month_key][:cash] += expense.amount
      when "card"
        monthly_totals[month_key][:card] += expense.amount
      else
        monthly_totals[month_key][:other] += expense.amount
      end
    end

    @monthly_rows = (0..months_back).map do |offset|
      month_start = (today - (months_back - offset).months).beginning_of_month
      totals = monthly_totals[month_start] || { cash: 0.to_d, card: 0.to_d, cash_in: 0.to_d, other: 0.to_d }
      total_spend = totals[:cash] + totals[:card] + totals[:other]
      {
        month: month_start.strftime("%b %Y"),
        cash: totals[:cash],
        card: totals[:card],
        other: totals[:other],
        cash_in: totals[:cash_in],
        total_spend: total_spend
      }
    end

    @max_spend = @monthly_rows.map { |row| row[:total_spend] }.max || 0.to_d
    @max_cash_in = @monthly_rows.map { |row| row[:cash_in] }.max || 0.to_d
    @max_cashflow_value = @monthly_rows.map { |row| [ row[:cash], row[:card], row[:other], row[:cash_in] ].max }.max || 0.to_d
    @total_spend = @monthly_rows.sum { |row| row[:total_spend] }
    @total_cash_in = @monthly_rows.sum { |row| row[:cash_in] }
    @net_total = @total_cash_in - @total_spend
    @cash_spend = @monthly_rows.sum { |row| row[:cash] }
    @card_spend = @monthly_rows.sum { |row| row[:card] }
    @other_spend = @monthly_rows.sum { |row| row[:other] }
  end
end
