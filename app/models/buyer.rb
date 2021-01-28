class Buyer < User
  has_one :order, as: :customer
end
