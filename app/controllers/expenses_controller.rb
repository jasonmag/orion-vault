class ExpensesController < ApplicationController
  before_action :authenticate_user!

  def index
    @expense = Expense.new
    load_expenses
    load_credit_card_types
  end

  def create
    @expense = current_user.expenses.new(expense_params)
    @expense.source = Expense::SOURCE_MANUAL

    if @expense.save
      redirect_to expenses_path, notice: "Expense was successfully added."
    else
      load_expenses
      load_credit_card_types
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    expense = current_user.expenses.find(params[:id])
    expense.destroy
    redirect_to expenses_path, notice: "Expense was successfully removed."
  end

  def edit
    @expense = current_user.expenses.find(params[:id])
    load_credit_card_types
  end

  def update
    expense = current_user.expenses.find(params[:id])

    if expense.update(expense_update_params(expense))
      redirect_to expenses_path, notice: "Payment method updated."
    else
      @expense = Expense.new
      load_expenses
      load_credit_card_types
      render :index, status: :unprocessable_entity
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:name, :amount, :paid_at, :payment_method, :credit_card_type_id)
  end

  def expense_update_params(expense)
    permitted = [ :payment_method, :credit_card_type_id ]
    if expense.source == Expense::SOURCE_MANUAL
      permitted += [ :name, :amount, :paid_at ]
    end

    params.require(:expense).permit(*permitted)
  end

  def load_credit_card_types
    @credit_card_types = current_user.user_setting&.credit_card_types&.order(created_at: :desc) || []
  end

  def load_expenses
    @per_page = 10
    @page = params.fetch(:page, 1).to_i
    @page = 1 if @page < 1

    scope = current_user.expenses.includes(:list).order(paid_at: :desc, created_at: :desc)
    @total_expenses = scope.count
    @total_pages = (@total_expenses.to_f / @per_page).ceil
    @page = @total_pages if @total_pages.positive? && @page > @total_pages

    offset = (@page - 1) * @per_page
    @expenses = scope.offset(offset).limit(@per_page)
  end
end
