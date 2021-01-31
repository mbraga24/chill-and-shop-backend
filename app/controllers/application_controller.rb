class ApplicationController < ActionController::API
  include ActionController::Helpers # ===> If you want to include the Helpers module while still keeping your applications as "rails-api" then simply include the module
  before_action :authenticate
  # helper_method :current_order

  def current_order
    if !@current_user.order.nil?
      Order.find(@current_user.order.id)
    else
      Order.create(customer: @current_user)
    end
  end

  def add_or_create_order_item(order, product_id, quantity)
		order_item = order.order_items.where('product_id = ?', product_id).first
		if order_item
			order_item.quantity += quantity
			order_item.save
		else
      order_item = order.order_items.create(product_id: product_id, quantity: quantity)
		end
		return order_item
  end
  
  def process_order(order_items)
    product_missing = []
		order_items.each do |o_item|
			product = Product.find(o_item.product_id)
			if product.quantity >= 1
				product.decrement!(:quantity, o_item.quantity)
        product.save
        
				OrderItem.find(o_item.id).destroy
			else	
				product_missing << product.id
			end
    end
    return product_missing
  end

  def encode_token(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')
  end

  def decode_token(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base, true, { algorithm: 'HS256' })[0]
  end

  # the rescue block will send an error message and an unauthorized status 
  # in case any errors are thrown inside the begin block. 
  def authenticate
    begin 
      # decode token using JWT library
      payload = decode_token(get_auth_token)
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