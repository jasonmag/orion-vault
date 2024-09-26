class CheckListHistoriesController < ApplicationController
  before_action :authenticate_user!

  def create
    list = List.find(params[:list_id])

    # Find an existing record for the user, list, and due_date, or initialize a new one
    check_list_history = CheckListHistory.find_or_initialize_by(
      user: current_user,
      list: list,
      due_date: params[:due_date]
    )

    # Update the checked status and checked_at timestamp
    check_list_history.checked = params[:checked]
    check_list_history.checked_at = DateTime.now if check_list_history.checked

    # Save the record (either create a new one or update the existing one)
    if check_list_history.save
      head :ok
    else
      render json: { errors: check_list_history.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
