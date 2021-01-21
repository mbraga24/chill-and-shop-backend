class Api::V1::OrderItemsController < ApplicationController
  skip_before_action :authenticate, only: [:create, :update, :destroy]

  def create
		@order = current_order
		@order_item = @order.order_items.new(order_item_params)
    session[:order_id] = @order.id
    if @order.save
      render json: { order_item: OrderItemSerializer.new(@order_item)  }
    else 
      render json: { errors: @order.errors.full_messages }
    end
	end

	def update
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

	def destroy
		@order = current_order
		@order_item = @order.order_items.find(params[:id])
		@order_item.destroy
		@order_items = @order.order_items
	end

	private
		def order_item_params
			params.require(:order_item).permit(:product_id, :quantity)
		end
end
