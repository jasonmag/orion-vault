module Api
  module V1
    module Auth
      class SessionsController < Devise::SessionsController
        respond_to :json
        before_action :ensure_json_request
        skip_before_action :verify_authenticity_token, raise: false

        private

        def ensure_json_request
          return if request.delete? && request.content_mime_type.nil?
          return if request.content_mime_type == Mime[:json]

          render json: { errors: [ "Content-Type must be application/json" ] }, status: :unsupported_media_type
        end

        def respond_with(resource, _opts = {})
          token = request.env["warden-jwt_auth.token"]
          render json: {
            data: {
              user: { id: resource.id, email: resource.email },
              token: token
            }
          }, status: :ok
        end

        def respond_to_on_destroy
          if current_user
            render json: { message: "Signed out" }, status: :ok
          else
            render json: { errors: [ "Not signed in" ] }, status: :unauthorized
          end
        end
      end
    end
  end
end
