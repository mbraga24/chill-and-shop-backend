class User < ApplicationRecord
  has_secure_password

  validates :email,
            presence: true, 
            uniqueness: { case_sensitive: false } 

  validate :password_cant_be_blank, :if => :password 

  scope :buyers, -> { where(type: 'Buyer') }
  scope :sellers, -> { where(type: 'Seller')}

  def password_cant_be_blank
    if !!password.present? && password.blank? 
      return errors.add :password, "can't be blank "
    end
  end
end
