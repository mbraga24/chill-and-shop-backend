class ApplicationController < ActionController::API
  include ActionController::Helpers # ===> If you want to include the Helpers module while still keeping your applications as "rails-api" then simply include the module
  before_action :authenticate
  
  # helper_method :current_order

  def current_order
    # byebug
    if !@current_user.order.nil?
      Order.find(@current_user.order.id)
    else
      # byebug
      Order.create(customer: @current_user)
    end
  end

  def add_item(order, product_id, quantity)
		# byebug
		order_item = order.order_items.where('product_id = ?', product_id).first
		if order_item
			# byebug
			# increase the quantity of product in cart
			order_item.quantity += quantity
			order_item.save
		else
			# byebug
			# product does not exist in cart
      order_item = order.order_items.create(product_id: product_id, quantity: quantity)
      # byebug
		end
		return order_item
	end

  def encode_token(payload)
    # Rails.application.secrets.secret_keybase
    JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')
  end

  def decode_token(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base, true, { algorithm: 'HS256' })[0]
  end

  def authenticate
    # byebug
    # JWT will throw an error if decoding doesn't succeed
    # We need to handle the error so the app doesn't crash

    # the rescue block will send an error message and an unauthorized status 
    # in case any errors are thrown inside the begin block. 
    begin 
      # decode token using JWT library
      payload = decode_token(get_auth_token)
      # byebug
      # get the user_id from the decoded token and use it to
      # set an instance variable for the current user
      set_current_user!(payload["user_id"])
    rescue
      render json: { error: 'Invalid Request' }, status: :unauthorized
    end
  end

  private 

  def get_auth_token
    auth_header = request.headers['Authorization']
    auth_header.split(' ')[1] if auth_header
  end

  def set_current_user!(id)
    @current_user = User.find(id)
  end

end