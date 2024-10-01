class ChangeDefaultCurrencyInUserSettingsToString < ActiveRecord::Migration[7.2]
  def change
    change_column :user_settings, :default_currency, :string
  end
end
