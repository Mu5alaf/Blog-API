class ApplicationController < ActionController::API
    before_action :authenticate_request
    private
    def authenticate_request
        # extract the Authorization header
        header = request.headers['Authorization']
        if header.present?
            token = header.split(' ').last # extract the token from Bearer <token>
            begin
                # decode the token using the secret key from credentials
                decoded = JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: 'HS256')[0]
                @current_user = User.find(decoded["user_id"]) # find the user associated with the token
            rescue JWT::DecodeError, ActiveRecord::RecordNotFound => e
                # handle invalid tokens or missing users
                render json: { error: 'Not Authorized' }, status: :unauthorized
            end
        else
            # handle missing Authorization header
            render json: { error: 'Missing Authorization Header' }, status: :unauthorized
        end
    end
# helper method to access the current user
    def current_user
        @current_user
    end
end
