module Api
  module V1
    class UserSettingsController < BaseController
      before_action :authenticate_user!
      before_action :set_user_setting

      def show
        render json: { data: user_setting_payload(@user_setting) }
      end

      def update
        if @user_setting.update(user_setting_params)
          render json: { data: user_setting_payload(@user_setting) }
        else
          render_validation_errors(@user_setting)
        end
      end

      private

      def set_user_setting
        @user_setting = current_user.user_setting || current_user.build_user_setting
      end

      def user_setting_params
        params.require(:user_setting).permit(:default_date_range_list_display, :default_currency, :notification_lead_time)
      end

      def user_setting_payload(setting)
        {
          id: setting.id,
          default_date_range_list_display: setting.default_date_range_list_display,
          default_currency: setting.default_currency,
          notification_lead_time: setting.notification_lead_time
        }
      end
    end
  end
end
