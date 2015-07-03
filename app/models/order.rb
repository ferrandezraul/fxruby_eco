require 'bigdecimal'

class Order < ActiveRecord::Base
	  belongs_to :customer  # Rows in order are children of rows in customer
  	has_many :line_items, :dependent => :destroy # Each order has many line_items referencing it.
                                                 # Each line_item contains a reference to its cart id
                                                 # The existence of line_items is dependent on the existence of the cart
    accepts_nested_attributes_for :line_items

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