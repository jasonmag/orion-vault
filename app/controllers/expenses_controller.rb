class ExpensesController < ApplicationController
  before_action :authenticate_user!

  def index
    @expense = Expense.new
    load_expenses
  end

  def create
    @expense = current_user.expenses.new(expense_params)
    @expense.source = Expense::SOURCE_MANUAL

    if @expense.save
      redirect_to expenses_path, notice: "Expense was successfully added."
    else
      load_expenses
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
  end

  def update
    expense = current_user.expenses.find(params[:id])

    if expense.update(expense_update_params)
      redirect_to expenses_path, notice: "Payment method updated."
    else
      @expense = Expense.new
      load_expenses
      render :index, status: :unprocessable_entity
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:name, :amount, :paid_at, :payment_method)
  end

  def expense_update_params
    params.require(:expense).permit(:payment_method)
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
