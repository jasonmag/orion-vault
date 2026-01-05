class UserSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_setting

  def show
  end

  def edit
    redirect_to user_setting_path
  end

  def update
    if @user_setting.update(user_setting_params)
      respond_to do |format|
        format.html { redirect_to user_setting_path, notice: "Settings updated!" }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "user_setting_status",
            partial: "user_settings/status",
            locals: { message: "Saved", variant: :success }
          )
        end
      end
    else
      respond_to do |format|
        format.html { render :show, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "user_setting_status",
            partial: "user_settings/status",
            locals: { message: "Check inputs and try again", variant: :error }
          ), status: :unprocessable_entity
        end
      end
    end
  end

  private

  def set_user_setting
    @user_setting = current_user.user_setting || current_user.build_user_setting
  end

  def user_setting_params
    params.require(:user_setting).permit(:default_date_range_list_display, :default_currency, :notification_lead_time)
  end
end
