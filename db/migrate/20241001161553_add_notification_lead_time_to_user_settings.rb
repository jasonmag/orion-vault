class AddNotificationLeadTimeToUserSettings < ActiveRecord::Migration[7.2]
  def change
    add_column :user_settings, :notification_lead_time, :integer
  end
end
