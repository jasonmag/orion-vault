class ListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list, only: %i[ show edit update destroy ]

  include DateSelectable

  # GET /lists or /lists.json
  def index
    @lists_with_due_dates = current_user.list.visible_or_once(@start_date, @end_date).flat_map do |list|
      due_dates = list.due_dates_within_range(@start_date, @end_date)
      due_dates.map { |due_date| { list: list, due_date: due_date } }
    end

    @lists_with_due_dates.sort_by! { |entry| entry[:due_date] }
  end

  def frequency
    today = Date.current
    @status = params[:status] == "expired" ? "expired" : "current"
    lists_scope = current_user.list.includes(:payment_schedule)

    if @status == "expired"
      lists_scope = lists_scope.where("effective_end_date IS NOT NULL AND effective_end_date < ?", today)
    else
      lists_scope = lists_scope.where("effective_start_date <= ?", today)
        .where("effective_end_date IS NULL OR effective_end_date >= ?", today)
    end

    @lists_by_frequency = lists_scope.order(:name).group_by do |list|
      list.payment_schedule&.frequency || "unscheduled"
    end
  end

  # GET /lists/1 or /lists/1.json
  def show
  end

  # GET /lists/new
  def new
    @list = List.new
    @list.build_payment_schedule # Initialize payment schedule for the form
  end

  # GET /lists/1/edit
  def edit
    @list.build_payment_schedule if @list.payment_schedule.nil? # Ensure a payment schedule exists for the form
  end

  # POST /lists or /lists.json
  def create
    @list = List.new(list_params)
    @list.user_id = current_user.id

    respond_to do |format|
      if @list.save
        format.html { redirect_to list_url(@list), notice: "List was successfully created." }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lists/1 or /lists/1.json
  def update
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to list_url(@list), notice: "List was successfully updated." }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1 or /lists/1.json
  def destroy
    @list.destroy

    respond_to do |format|
      format.html { redirect_to lists_url, notice: "List was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def select_dates
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = current_user.list.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def list_params
      params.require(:list)
        .permit(:name, :price, :description, :effective_start_date, :effective_end_date,
              payment_schedule_attributes: [ :frequency, :day_of_month, :day_of_week, :month_of_year, :notification_lead_time ])
    end
end
