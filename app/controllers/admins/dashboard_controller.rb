class Admins::DashboardController < ApplicationController
  before_action :authenticate_admin!

  def index
    load_dashboard_data

    respond_to do |format|
      format.html
      format.csv { send_data list_export_csv, filename: "lists-#{Time.current.to_date}.csv" }
    end
  end

  private

  def load_dashboard_data
    @metrics = {
      admins: Admin.count,
      users: User.count,
      lists_total: List.unscoped.count,
      lists_active: List.count,
      payment_schedules: PaymentSchedule.count,
      check_ins: CheckListHistory.count
    }

    @recent_users = User.order(created_at: :desc).limit(5)
    @recent_lists = List.unscoped.includes(:user, :payment_schedule).order(created_at: :desc).limit(5)
    @recent_activity = CheckListHistory.includes(:user, :list).order(created_at: :desc).limit(5)
  end

  def list_export_csv
    rows = []
    rows << [ "List", "Owner email", "Price", "Effective start", "Effective end", "Status", "Created at" ].join(",")

    List.unscoped.includes(:user).find_each do |list|
      rows << [
        list.name,
        list.user&.email || "Unknown owner",
        list.price,
        list.effective_start_date,
        list.effective_end_date,
        list.deleted? ? "Archived" : "Active",
        list.created_at
      ].map { |value| csv_escape(value) }.join(",")
    end

    rows.join("\n")
  end

  def csv_escape(value)
    sanitized = formatted_value(value)
    needs_quotes = sanitized.include?('"') || sanitized.include?(',') || sanitized.include?("\n")
    sanitized = sanitized.gsub('"', '""')
    needs_quotes ? "\"#{sanitized}\"" : sanitized
  end

  def formatted_value(value)
    return "" if value.nil?

    return value.iso8601 if value.respond_to?(:iso8601)

    value.to_s
  end
end
