require 'active_record'

class Product < ActiveRecord::Base
	has_one :line_item  #, :dependent => :nullify # Each product has many line_items referencing it.
										  # Each line_item contains a reference to its product id
										  # Do not destroy line items when products are destroyed (Keep them in database)

	validates :name, presence: true, uniqueness: true
	validates :price, presence: true
	validates :price_type, presence: true    # por_unidad o por_kilo
	validates :tax_percentage, presence: true

	before_save :calculate
	#before_destroy :check_for_line_item

	module PriceType
	    POR_KILO      = "por_kilo"
	    POR_UNIDAD    = "por_unidad"
	end

  private

  def check_for_line_item
    if line_item.valid?
      errors.add_to_base("cannot delete product while line item exist")
      return false
    end
  end

	def calculate
		self.taxes, self.total = BigDecimal.new("0.0"), BigDecimal.new("0.0")
		self.taxes = ( self.price * self.tax_percentage / 100 )
		self.total = self.price + self.taxes
	end
end
