class Order < ActiveRecord::Base
	belongs_to :customer
  	has_many :line_items
  	has_many :products, :through => :line_items

  	before_save :calculate_prices

  	def calculate_prices
  		self.price, self.taxes, self.total = 0, 0, 0
  		if self.line_items
			if (self.line_items.count > 0)
				self.line_items.each do | item |
					self.price += item.price
					self.taxes += item.taxes
					self.total += item.total
				end
			end
		end
	end

  	def items_to_s
  		text = String.new

  		if self.line_items 
  			puts "line items exist"
  			self.line_items.each_with_index do |line_item, index|
  				text << line_item.to_s
		      	if index != self.line_items.size - 1
		        	text << "\n"
		      	end
		    end
	    end

	    text
	end
end