module Api
  module V1
    class ListsController < BaseController
      before_action :authenticate_user!
      before_action :set_list, only: [ :show, :update, :destroy ]
      before_action :set_date_range, only: [ :index, :show, :create, :update ]

      def index
        lists = current_user.list.visible_or_once(@start_date, @end_date).includes(:payment_schedule)
        items = lists.flat_map do |list|
          list.due_dates_within_range(@start_date, @end_date).map do |due_date|
            list_payload(list, due_date: due_date)
          end
        end

        items.sort_by! { |entry| entry[:due_date] }

        render json: {
          data: items,
          meta: { start_date: @start_date, end_date: @end_date }
        }
      end

      def frequency
        today = Date.current
        status = params[:status] == "expired" ? "expired" : "current"
        lists_scope = current_user.list.includes(:payment_schedule)

        if status == "expired"
          lists_scope = lists_scope.where("effective_end_date IS NOT NULL AND effective_end_date < ?", today)
        else
          lists_scope = lists_scope.where("effective_start_date <= ?", today)
            .where("effective_end_date IS NULL OR effective_end_date >= ?", today)
        end

        grouped = lists_scope.order(:name).group_by do |list|
          list.payment_schedule&.frequency || "unscheduled"
        end

        render json: {
          data: grouped.transform_values { |lists| lists.map { |list| list_payload(list) } },
          meta: { status: status }
        }
      end

      def show
        render json: { data: list_payload(@list, include_due_dates: true) }
      end

      def create
        list = current_user.list.new(list_params)
        if list.save
          render json: { data: list_payload(list, include_due_dates: true) }, status: :created
        else
          render_validation_errors(list)
        end
      end

      def update
        if @list.update(list_params)
          render json: { data: list_payload(@list, include_due_dates: true) }
        else
          render_validation_errors(@list)
        end
      end

      def destroy
        @list.destroy
        head :no_content
      end

      private

      def set_list
        @list = current_user.list.find(params[:id])
      end

      def set_date_range
        if params[:start_date].present? && params[:end_date].present?
          @start_date = Date.parse(params[:start_date])
          @end_date = Date.parse(params[:end_date])
        else
          default_days = current_user.user_setting&.default_date_range_list_display.to_i
          default_days = 5 if default_days <= 0
          @start_date = Date.today - default_days
          @end_date = Date.today + default_days
        end
      rescue Date::Error
        render json: { errors: [ "Invalid date format" ] }, status: :bad_request
      end

      def list_params
        params.require(:list)
          .permit(:name, :price, :description, :effective_start_date, :effective_end_date,
            payment_schedule_attributes: [ :id, :frequency, :day_of_month, :day_of_week, :month_of_year, :notification_lead_time ])
      end

      def list_payload(list, due_date: nil, include_due_dates: false)
        payload = {
          id: list.id,
          name: list.name,
          price: list.price,
          description: list.description,
          effective_start_date: list.effective_start_date,
          effective_end_date: list.effective_end_date,
          payment_schedule: payment_schedule_payload(list.payment_schedule)
        }

        if due_date
          payload[:due_date] = due_date
          payload[:checked] = list.checked_status_for(current_user, due_date)
        end

        if include_due_dates
          payload[:due_dates] = list.due_dates_within_range(@start_date, @end_date).map do |date|
            {
              due_date: date,
              checked: list.checked_status_for(current_user, date)
            }
          end
        end

        payload
      end

      def payment_schedule_payload(schedule)
        return nil unless schedule

        {
          id: schedule.id,
          frequency: schedule.frequency,
          day_of_month: schedule.day_of_month,
          day_of_week: schedule.day_of_week,
          month_of_year: schedule.month_of_year,
          notification_lead_time: schedule.notification_lead_time
        }
      end
    end
  end
end
