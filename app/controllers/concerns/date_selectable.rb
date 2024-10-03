# app/controllers/concerns/date_selectable.rb
module DateSelectable
  extend ActiveSupport::Concern

  included do
    before_action :set_dates, only: [ :index, :select_dates ]
  end

  def select_dates
    # Render the view to select start_date and end_date
  end

  private

  # Sets the @start_date and @end_date, using params, session, or default values
  def set_dates
    if params[:start_date].present? && params[:end_date].present?
      # If params are passed, parse them to Date objects and update the session
      @start_date = session[:start_date] = Date.parse(params[:start_date])
      @end_date = session[:end_date] = Date.parse(params[:end_date])
    elsif session[:start_date].present? && session[:end_date].present?
      # If no params but session values exist, ensure they are Date objects
      @start_date = session[:start_date].to_date
      @end_date = session[:end_date].to_date
    else
      # If no params or session, use the default date range
      user_default_dates
    end
  end

  def user_default_dates
    default_dates = current_user.user_setting.default_date_range_list_display.to_i || 5
    @start_date = Date.today - default_dates
    @end_date = Date.today + default_dates
  end
end
