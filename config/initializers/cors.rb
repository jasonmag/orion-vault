Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(*begin
      allowed = ENV.fetch("API_ALLOWED_ORIGINS", "").split(",").map(&:strip).reject(&:empty?)
      allowed = [
        "http://localhost:3000",
        "http://127.0.0.1:3000",
        "http://localhost:3001",
        "http://127.0.0.1:3001"
      ] if allowed.empty?
      allowed
    end)

    resource "/api/*",
      headers: :any,
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ]
  end
end
