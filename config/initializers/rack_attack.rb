class Rack::Attack
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

  self.throttled_responder = lambda do |_env|
    [ 429, { "Content-Type" => "text/plain" }, [ "Too many attempts. Try again later." ] ]
  end
end
