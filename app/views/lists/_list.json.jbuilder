json.extract! list, :id, :name, :price, :description, :due_date, :user_id, :created_at, :updated_at
json.url list_url(list, format: :json)
