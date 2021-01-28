class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate, only: [:create, :index]
  wrap_parameters :user, include: [:first_name, :last_name, :email, :password]

  def index
    users = User.all
    render json: users
  end

  def create 
    user = User.create(user_params)

    if user.valid?
      token = encode_token({ user_id: user.id })
      render json: { user: UserSerializer.new(user), token: token, success: "Hooray! Welcome to HmShop, #{user.first_name}!" }, status: :created
    else
      render json: { header: "Check the error(s) bellow:" , error: user.errors.full_messages }, status: :bad_request
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end
