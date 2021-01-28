class Api::V1::SessionsController < ApplicationController
  wrap_parameters :user, include: [:email, :password] 
  skip_before_action :authenticate, only: [:login]
  # before_action :authenticate, only: [:autologin]
  
  def login
    user = User.find_by(email: user_credentials_params[:email])

    if user && user.authenticate(user_credentials_params[:password])
      token = encode_token({ user_id: user.id })
      render json: { user: UserSerializer.new(user), token: token, confirmation: "Welcome back, #{user.first_name}!" }, status: :accepted
    else
      render json: { header: "Invalid email or password", error: [] }, status: :unauthorized
    end
  end

  def autologin
    # byebug
    render json: { user: UserSerializer.new(@current_user) }, status: :ok
    # render json: @current_user, status: :ok
  end

  private 

  def user_credentials_params
    params.require(:user).permit(:email, :password)
  end
end
