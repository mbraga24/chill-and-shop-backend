class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :unit_price, :total_price, :quantity, :product

  def product
    product = Product.find_by(id: object.product_id)
    return {
      title: product.title,
      image_url: product.image_url,
      quantity: product.quantity,
      seller: product.seller
    }
  end
end
