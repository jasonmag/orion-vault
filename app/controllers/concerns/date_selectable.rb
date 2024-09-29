# app/controllers/concerns/date_selectable.rb
module DateSelectable
  extend ActiveSupport::Concern

  included do
    before_action :set_dates, only: :index
  end

  def select_dates
    # This action will render the view to select start_date and end_date
  end

  private

  def set_dates
    @start_date = params[:start_date]
    @end_date = params[:end_date]
  end
end
