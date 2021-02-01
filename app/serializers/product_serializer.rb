class ProductSerializer < ActiveModel::Serializer
  attributes :id, :title, :price, :quantity, :image_url, :seller

  def seller
    seller = User.find_by(id: object.seller_id)
    return UserSerializer.new(seller)
  end 
end