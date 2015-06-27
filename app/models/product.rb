require 'active_record'

class Product < ActiveRecord::Base
	belongs_to :line_item
	belongs_to :order

	validates :name, presence: true, uniqueness: true
	validates :price, presence: true
	validates :price_type, presence: true    # por_unidad o por_kilo
	validates :tax_percentage, presence: true

	before_save :calculate

	module PriceType
	    POR_KILO      = "por_kilo"
	    POR_UNIDAD    = "por_unidad"
	end

	def calculate
		self.taxes = ( self.price * self.tax_percentage / 100 )
		self.total = self.price + self.taxes
	end
end
