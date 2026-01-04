class CheckListHistoriesController < ApplicationController
  before_action :authenticate_user!

  def create
    list = List.find(params[:list_id])
    due_date = Date.parse(params[:due_date].to_s) rescue nil
    checked = ActiveModel::Type::Boolean.new.cast(params[:checked])

    # Find an existing record for the user, list, and due_date, or initialize a new one
    check_list_history = CheckListHistory.find_or_initialize_by(
      user: current_user,
      list: list,
      due_date: due_date
    )

    # Update the checked status and checked_at timestamp
    check_list_history.checked = checked
    check_list_history.checked_at = DateTime.now if check_list_history.checked

    # Save the record (either create a new one or update the existing one)
    if check_list_history.save
      if due_date.present?
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
      end
      head :ok
    else
      render json: { errors: check_list_history.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
