class LineItem < ActiveRecord::Base
	belongs_to :order
	has_one :product
	has_one :customer, through: :order

	validates :product, presence: true
	validates :quantity, presence: true

	before_save :calculate_price

	def calculate_price
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