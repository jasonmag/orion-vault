class CreateUserSettings < ActiveRecord::Migration[7.2]
  def change
    create_table :user_settings do |t|
      t.string :default_date_range_list_display
      t.string :default_currency
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
