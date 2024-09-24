class CreateCheckListHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :check_list_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :list, null: false, foreign_key: true
      t.date :due_date, null: false
      t.datetime :checked_at
      t.boolean :checked

      t.timestamps
    end
  end
end
