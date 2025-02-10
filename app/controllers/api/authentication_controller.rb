class Api::AuthenticationController < ApplicationController
    #skip auth befor this actions
    skip_before_action :authenticate_request, only: [:signup, :login]

    #signup
    def signup
        user = User.new(user_params)
        if user.save
            token = encode_token(user_id: user.id)
            render json: {user: user, token: token}, status: :created
        else
            render json: {error: user.errors.full_messages}, status: :unprocessable_entity
        end
    end

    #login
    def login
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
            token = encode_token(user_id: user.id)
            render json: { user: user, token: token }, status: :ok
        else
            render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
    end
    
    def user_params
        params.permit(:name, :email, :password, :password_confirmation, :image)
    end

    #method to encode a token
    def encode_token(payload)
        secret = Rails.application.credentials.secret_key_base
        JWT.encode(payload, secret)
    end
end
