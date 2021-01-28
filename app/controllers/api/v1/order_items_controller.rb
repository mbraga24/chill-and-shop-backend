class Api::V1::OrderItemsController < ApplicationController
	skip_before_action :authenticate, only: [:update, :destroy]

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

	def update
		byebug
		@order = current_order
		@order_item = @order.order_items.find(params[:id])
		@order_item.update_attributes(order_item_params)
    if @order_item.update_attributes(order_item_params)
      @order_items = @order.order_items
      render json: { order_items: order_items }
    else
      render json: { errors: @order_item.errors.full_messages }
    end
	end

	def delete_order_item
		order = current_order
		order_item = order.order_items.find(params[:id])
		order_item.destroy
		render json: { orderItem: OrderItemSerializer.new(order_item), orderTotal: order.total, confirmation: "Order deleted successfully." }, status: :accepted
	end

	private
		def order_item_params
			params.require(:order_item).permit(:product_id, :quantity)
		end
end
