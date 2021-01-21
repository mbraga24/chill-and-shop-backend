class Api::V1::ProductsController < ApplicationController
  skip_before_action :authenticate, only: [:index, :create, :filter_products]

  def index
    products = Product.all
    render json: products 
  end

  def create
    # product = Product.new(product_params)
    product = Product.create(
      name: params[:name], 
      price: params[:price], 
      quantity: params[:quantity].to_i,
    )
    if product.valid?
      render json: { product: ProductSerializer.new(product) }, status: :created
    else
      render json: { errors: @product.errors.full_messages }
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
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to products_path    
  end

  private
    def product_params
      params.require(:product).permit(:title, :price, :type)
    end
end
