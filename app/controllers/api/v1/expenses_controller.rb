module Api
  module V1
    class ExpensesController < BaseController
      before_action :authenticate_user!
      before_action :set_expense, only: [ :update, :destroy ]

      def index
        per_page = params.fetch(:per_page, 10).to_i
        per_page = 10 if per_page <= 0
        per_page = 100 if per_page > 100

        page = params.fetch(:page, 1).to_i
        page = 1 if page <= 0

        scope = current_user.expenses.includes(:list).order(paid_at: :desc, created_at: :desc)
        total = scope.count
        total_pages = (total.to_f / per_page).ceil
        page = total_pages if total_pages.positive? && page > total_pages

        expenses = scope.offset((page - 1) * per_page).limit(per_page)

        render json: {
          data: expenses.map { |expense| expense_payload(expense) },
          meta: { page: page, per_page: per_page, total: total, total_pages: total_pages }
        }
      end

      def create
        expense = current_user.expenses.new(expense_params)
        expense.source = Expense::SOURCE_MANUAL

        if expense.save
          render json: { data: expense_payload(expense) }, status: :created
        else
          render_validation_errors(expense)
        end
      end

      def update
        if @expense.update(expense_update_params)
          render json: { data: expense_payload(@expense) }
        else
          render_validation_errors(@expense)
        end
      end

      def destroy
        @expense.destroy
        head :no_content
      end

      private

      def set_expense
        @expense = current_user.expenses.find(params[:id])
      end

      def expense_params
        params.require(:expense).permit(:name, :amount, :paid_at, :payment_method, :list_id)
      end

      def expense_update_params
        params.require(:expense).permit(:name, :amount, :paid_at, :payment_method, :list_id)
      end

      def expense_payload(expense)
        {
          id: expense.id,
          name: expense.name,
          amount: expense.amount,
          paid_at: expense.paid_at,
          payment_method: expense.payment_method,
          source: expense.source,
          due_date: expense.due_date,
          list: expense.list ? { id: expense.list.id, name: expense.list.name } : nil
        }
      end
    end
  end
end
