class Api::V1::OrderItemsController < ApplicationController
	def index 
		order = current_order
		render json: {
			orders: order.order_items.map { |item|
				OrderItemSerializer.new(item).attributes
			},
			totalOrder: order.total
		}
	end

	def create
		order = current_order
		order_item = add_or_create_order_item(order, params[:product_id], params[:quantity])
		if order.valid? && order_item.valid?
			order.save
      render json: { orderItem: OrderItemSerializer.new(order_item), orderTotal: order.total, confirmation: "Product added to you cart." }, status: :created
    else 
      render json: { errors: order.errors.full_messages }, status: :bad_request
		end
	end

	def update_order_item
		order = current_order
		order_item = order.order_items.find(params[:id])
		order_item.update_attributes(order_item_params)
		if order_item.update_attributes(order_item_params)
			order_item.save
      render json: { orderItem: OrderItemSerializer.new(order_item), orderTotal: order.total, confirmation: "Your order has been successfully updated." }, status: :accepted
    else
      render json: { errors: @order_item.errors.full_messages }, status: :bad_request
    end
	end

	def delete_order_item
		order = current_order
		order_item = order.order_items.find(params[:id])
		order_item.destroy
		render json: { orderItem: OrderItemSerializer.new(order_item), orderTotal: order.total, confirmation: "Order deleted successfully." }, status: :accepted
	end

	def place_order
		order = current_order 
		if order
			product_missing = process_order(order.order_items)			

			if !product_missing.empty?
				render json: { error: true, confirmation: "We're sorry. Some of the items in your shopping cart are no longer available. Please update your shopping cart and try again." }, status: :conflict
			else 
				render json: { confirmation: "Order completed. Thank you for shopping!" }, status: :ok
			end

		else
			render json: { error: true, confirmantion: "Something went wrong while placing your order. Please try again in a few minutes." }, status: :bad_request
		end
	end

	private
		def order_item_params
			params.require(:order_item).permit(:product_id, :quantity)
		end
end
