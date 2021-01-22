class Product < ApplicationRecord
  has_many :order_items
  belongs_to :seller, class_name: "Seller"
  # has_many :customers, class_name: "Customer"
end
