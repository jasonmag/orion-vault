class AddCreditCardTypeToExpenses < ActiveRecord::Migration[8.0]
  def change
    add_reference :expenses, :credit_card_type, null: true, foreign_key: true
  end
end
