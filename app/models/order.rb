require 'bigdecimal'

class Order < ActiveRecord::Base
	belongs_to :customer
  	has_many :line_items, :dependent => :destroy
  	has_many :products, :through => :line_items

  	before_save :calculate_prices

  	def calculate_prices
  		self.price, self.taxes, self.total = BigDecimal.new("0.0"), BigDecimal.new("0.0"), BigDecimal.new("0.0")
  		if self.line_items
			if (self.line_items.length > 0)
				self.line_items.each do | item |
					self.price += item.price
					self.taxes += item.taxes
					self.total += item.total
				end
			end
		end
	end
end