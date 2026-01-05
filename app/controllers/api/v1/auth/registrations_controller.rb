module Api
  module V1
    module Auth
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json
        before_action :ensure_json_request
        skip_before_action :verify_authenticity_token, raise: false

        private

        def ensure_json_request
          return if request.content_mime_type == Mime[:json]

          render json: { errors: [ "Content-Type must be application/json" ] }, status: :unsupported_media_type
        end

        def respond_with(resource, _opts = {})
          if resource.persisted?
            token = request.env["warden-jwt_auth.token"]
            render json: {
              data: {
                user: { id: resource.id, email: resource.email },
                token: token
              }
            }, status: :created
          else
            render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
