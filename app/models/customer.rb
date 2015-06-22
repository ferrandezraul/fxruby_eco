require 'active_record'

class Customer < ActiveRecord::Base
  has_many :orders
  
  validates :name, presence: true
  validates :address, presence: true
  validates :nif, presence: true
  validates :customer_type, presence: true

  module Type
  	COOPERATIVA = "Cooperativa"
  	TIENDA 		= "Tienda"
  	CLIENTE		= "Cliente"
  end
  
end