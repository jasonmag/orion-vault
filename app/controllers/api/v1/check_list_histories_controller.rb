module Api
  module V1
    class CheckListHistoriesController < BaseController
      before_action :authenticate_user!

      def create
        list = current_user.list.find(params[:list_id])
        due_date = Date.parse(params[:due_date].to_s)
        checked = ActiveModel::Type::Boolean.new.cast(params[:checked])

        check_list_history = CheckListHistory.find_or_initialize_by(
          user: current_user,
          list: list,
          due_date: due_date
        )

        check_list_history.checked = checked
        check_list_history.checked_at = DateTime.now if check_list_history.checked

        if check_list_history.save
          if checked
            expense = Expense.find_or_initialize_by(
              user: current_user,
              list: list,
              due_date: due_date,
              source: Expense::SOURCE_DUE
            )
            expense.assign_attributes(
              name: list.name,
              amount: list.price,
              paid_at: Date.current
            )
            expense.save!
          else
            Expense.where(
              user: current_user,
              list: list,
              due_date: due_date,
              source: Expense::SOURCE_DUE
            ).destroy_all
          end

          render json: {
            data: {
              id: check_list_history.id,
              list_id: list.id,
              due_date: due_date,
              checked: checked
            }
          }
        else
          render_validation_errors(check_list_history)
        end
      rescue Date::Error
        render json: { errors: [ "Invalid date format" ] }, status: :bad_request
      end
    end
  end
end
