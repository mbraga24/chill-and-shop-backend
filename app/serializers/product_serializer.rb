class ProductSerializer < ActiveModel::Serializer
  attributes :id, :title, :price, :quantity, :image_url, :seller

  def seller
    seller = User.find_by(id: object.seller_id)
    return UserSerializer.new(seller)
  end 

  # def seller
  #   # seller = User.where(id: object.user.id, type: "Seller")
  #   return UserSerializer.new(seller)
  # end 
end

# @permission = Permission.where(:user_id=>params[:user_id]).where(:project_id=>params[:project_id]).first