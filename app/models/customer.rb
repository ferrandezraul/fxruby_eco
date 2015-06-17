class Customer < ActiveRecord::Base
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