class CreateExpenses < ActiveRecord::Migration[7.2]
  def change
    create_table :expenses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :list, null: true, foreign_key: true
      t.string :name, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.date :paid_at, null: false
      t.string :payment_method
      t.string :source, null: false
      t.date :due_date

      t.timestamps
    end
  end
end
