require 'active_record'
require 'ancestry'

class Product < ActiveRecord::Base
	has_one :line_item  # Each product has many line_items referencing it.
										  # Each line_item contains a reference to its product id
	has_ancestry									  

	validates :name, presence: true, uniqueness: true
	validates :price, presence: true
	validates :price_type, presence: true    # por_unidad o por_kilo
	validates :tax_percentage, presence: true

	before_save :calculate
	before_destroy :check_for_line_item

	module PriceType
	    POR_KILO      = "por_kilo"
	    POR_UNIDAD    = "por_unidad"
	end

	# Returns if Product is outdated
	# outdated means that Product was wanted to be destroyed but was kept to
	# maintain integrity in database for orders that were previously created
	# with that Product. (See before_destroy) 
	# User can filter those products by checking this attribute.
	def is_outdated?
		self.outdated
	end

  private

  def check_for_line_item
    if line_item
    	@@LOG ||= Logger.new('error.log')
      @@LOG.info "cannot delete product while line item exist"
      self.outdated = true 
      return false # Do not destroy them from database
    end
  end

	def calculate
		self.taxes, self.total = BigDecimal.new("0.0"), BigDecimal.new("0.0")
		self.taxes = ( self.price * self.tax_percentage / 100 )
		self.total = self.price + self.taxes
	end
end
