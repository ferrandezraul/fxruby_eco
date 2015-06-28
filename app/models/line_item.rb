class LineItem < ActiveRecord::Base
	belongs_to :order
	has_one :product
	has_one :customer, through: :order

	validates :product, presence: true
	validates :quantity, presence: true

	before_save :calculate_price

	def calculate_price
		self.total, self.price, self.taxes = 0, 0, 0
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

	def to_s
		text = String.new
		if self.product && self.quantity && self.weight && self.total
			if self.product.price_type == Product::PriceType::POR_UNIDAD
				text << "%d x %s = %d EUR" % [self.quantity, self.product.name, self.total]
			elsif self.product.price_type == Product::PriceType::POR_KILO
				text << "%d x %d Kg %s = %d EUR" % [self.quantity, self.weight, self.product.name, self.total]
			end
		end

		text
	end

end