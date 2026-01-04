class ExpensesController < ApplicationController
  before_action :authenticate_user!

  def index
    @expense = Expense.new
    @expenses = current_user.expenses.includes(:list).order(paid_at: :desc, created_at: :desc)
  end

  def create
    @expense = current_user.expenses.new(expense_params)
    @expense.source = Expense::SOURCE_MANUAL

    if @expense.save
      redirect_to expenses_path, notice: "Expense was successfully added."
    else
      @expenses = current_user.expenses.includes(:list).order(paid_at: :desc, created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    expense = current_user.expenses.find(params[:id])
    expense.destroy
    redirect_to expenses_path, notice: "Expense was successfully removed."
  end

  private

  def expense_params
    params.require(:expense).permit(:name, :amount, :paid_at, :payment_method)
  end
end
