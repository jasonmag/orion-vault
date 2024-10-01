class UserSettingsController < ApplicationController
  before_action :set_user_setting

  def show
  end

  def update
    if @user_setting.update(user_setting_params)
      redirect_to user_setting_path, notice: "Settings were successfully updated."
    else
      render :show
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
