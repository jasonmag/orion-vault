module Api
  module V1
    class BaseController < ActionController::API
      include Devise::Controllers::Helpers
      include ActionController::MimeResponds

      before_action :ensure_json_request
      after_action :set_security_headers

      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from ActionController::ParameterMissing, with: :render_bad_request

      private

      def ensure_json_request
        return if request.get? || request.head?
        return if request.content_mime_type == Mime[:json]

        render json: { errors: [ "Content-Type must be application/json" ] }, status: :unsupported_media_type
      end

      def set_security_headers
        response.headers["X-Content-Type-Options"] = "nosniff"
        response.headers["Cache-Control"] = "no-store"
        response.headers["Pragma"] = "no-cache"
        response.headers["Referrer-Policy"] = "strict-origin-when-cross-origin"
      end

      def render_not_found
        render json: { errors: [ "Not found" ] }, status: :not_found
      end

      def render_bad_request(error)
        render json: { errors: [ error.message ] }, status: :bad_request
      end

      def render_validation_errors(resource)
        render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
