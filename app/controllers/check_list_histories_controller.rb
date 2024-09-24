class CheckListHistoriesController < ApplicationController
  before_action :authenticate_user!

  def create
    list = List.find(params[:list_id])

    # Create a check history record
    CheckListHistory.create!(
      user: current_user,
      list: list,
      checked_at: DateTime.now,
      checked: params[:checked],
      due_date: params[:due_date]
    )

    head :ok
  end
end
