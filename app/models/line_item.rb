class LineItem < ActiveRecord::Base
	belongs_to :product # Rows in line_items are children of rows in product
	belongs_to :order # Rows in line_items are children of rows in order

	validates :product, presence: true
	validates :quantity, presence: true

	accepts_nested_attributes_for :product

	before_save :calculate_price

	def calculate_price
		self.total, self.price, self.taxes = BigDecimal.new("0.0"), BigDecimal.new("0.0"), BigDecimal.new("0.0")
		if self.product.price_type == Product::PriceType::POR_KILO
			if (self.weight > 0)
				self.price = self.quantity * self.weight * self.product.price
			end
		elsif self.product.price_type == Product::PriceType::POR_UNIDAD
			self.price = self.quantity * self.product.price
		end

		self.taxes = self.price * self.product.tax_percentage / 100
		self.total = self.price + self.taxes
	end

end