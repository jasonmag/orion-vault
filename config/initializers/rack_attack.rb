require "json"

class Rack::Attack
  def self.api_request?(req)
    req.path.start_with?("/api/")
  end

  def self.api_write_request?(req)
    api_request?(req) && (req.post? || req.put? || req.patch? || req.delete?)
  end

  # Throttle login attempts by IP.
  throttle("logins/ip", limit: 5, period: 20.seconds) do |req|
    if req.path == "/users/sign_in" || req.path == "/admins/sign_in"
      req.ip
    end
  end

  # Throttle login attempts by email.
  throttle("logins/email", limit: 5, period: 20.seconds) do |req|
    next unless req.post?
    next unless req.path == "/users/sign_in" || req.path == "/admins/sign_in"

    req.params.dig("user", "email") || req.params.dig("admin", "email")
  end

  # Throttle all API requests by IP.
  throttle("api/ip", limit: 300, period: 5.minutes) do |req|
    req.ip if api_request?(req)
  end

  # Tighter throttling for write-heavy API requests.
  throttle("api/write/ip", limit: 60, period: 1.minute) do |req|
    req.ip if api_write_request?(req)
  end

  # Tighter throttling for API authentication endpoints.
  throttle("api/auth/ip", limit: 10, period: 1.minute) do |req|
    req.ip if req.post? && req.path.start_with?("/api/v1/auth/")
  end

  self.throttled_responder = lambda do |env|
    req = Rack::Request.new(env)
    if api_request?(req)
      body = JSON.generate({ errors: [ "Rate limit exceeded. Try again later." ] })
      [ 429, { "Content-Type" => "application/json" }, [ body ] ]
    else
      [ 429, { "Content-Type" => "text/plain" }, [ "Too many attempts. Try again later." ] ]
    end
  end
end
