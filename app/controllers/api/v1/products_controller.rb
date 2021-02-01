class Api::V1::ProductsController < ApplicationController
  skip_before_action :authenticate, only: [:index, :filter_products]

  def index
    products = Product.all
    render json: products 
  end

  def create
    product = Product.new(
      title: params[:title], 
      price: params[:price].to_f, 
      quantity: params[:quantity].to_i,
      seller: @current_user
    )
    if product.valid?
      image = Cloudinary::Uploader.upload(params[:file])
      product[:image_url] = image["url"]
      product.save
      render json: { product: ProductSerializer.new(product), confirmation: "Successfully added to inventory." }, status: :created
    else
      render json: { errors: product.errors.full_messages }, status: :bad_request
    end
  end

  def filter_products
    products = Product.where("lower(#{params[:type]}) like lower(?)", "%#{params[:query]}%")
    render json: products, status: :ok
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(product_params)
      redirect_to products_path
    else
      render 'edit'
    end
  end

  def destroy
    product = Product.find(params[:id])

    link_array = product.image_url.split("/")
    identifier = link_array[link_array.length - 1].split(".")[0]
    result = Cloudinary::Uploader.destroy(identifier)
    
    if result.value?("ok")
      product.destroy
      render json: { product: ProductSerializer.new(product), confirmation: "Product deleted successfully!" }, status: :accepted
    else
      render json: { error: "Something went wrong! Try again later." }, status: :bad_request
    end
  end

  private
    def product_params
      params.require(:product).permit(:title, :price, :type)
    end
end
