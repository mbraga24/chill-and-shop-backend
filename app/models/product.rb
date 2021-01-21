class Product < ApplicationRecord
  has_many :order_items
  has_many :sellers, class_name: "Seller"
  has_many :customers, class_name: "Customer"
end
