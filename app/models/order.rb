class Order < ActiveRecord::Base
	belongs_to :customer
  	has_many :line_items
  	has_many :products, :through => :line_items


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