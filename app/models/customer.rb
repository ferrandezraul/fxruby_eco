require 'active_record'

class Customer < ActiveRecord::Base

  module Type
    COOPERATIVA = "Cooperativa"
    TIENDA    = "Tienda"
    CLIENTE   = "Cliente"
  end
  
  has_many :orders
  
  validates :name, presence: true
  validates :address, presence: true
  validates :nif, presence: true
  validates :customer_type, presence: true, inclusion: [Type::COOPERATIVA, Type::TIENDA, Type::CLIENTE]
  
end