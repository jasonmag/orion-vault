json.extract! list, :id, :name, :price, :description, :user_id, :created_at, :updated_at
json.url list_url(list, format: :json)
