class UserTokenController < ApplicationController
  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.valid_password?(params[:password]) && @user.confirmed?
      # Generate a JWT token to use for authentication
      jwt = JWT.encode({ user_id: @user.id }, Rails.application.secrets.secret_key_base)

      # Return the JWT token as part of the response
      render json: { jwt: jwt }, status: :created
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end
end