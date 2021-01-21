class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :unit_price, :total_price, :quantity, :product_id, :order_id
end
