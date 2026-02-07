class CreateCreditCardTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :credit_card_types do |t|
      t.string :bank_name, null: false
      t.string :last4, null: false
      t.references :user_setting, null: false, foreign_key: true

      t.timestamps
    end
  end
end
