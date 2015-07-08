class LineItem < ActiveRecord::Base
	belongs_to :product # Rows in line_items are children of rows in product
	belongs_to :order # Rows in line_items are children of rows in order

	# A product might contain subproducts
  # This is an implementation of the composite design pattern
  # See http://stackoverflow.com/questions/17603142/implementing-the-composite-pattern-in-ruby-on-rails
	has_and_belongs_to_many :children,
    :class_name => "LineItem",
    :join_table => "children_containers",
    :foreign_key => "container_id",
    :association_foreign_key => "child_id"

  has_and_belongs_to_many :containers,
    :class_name => "LineItem",
    :join_table => "children_containers",
    :foreign_key => "child_id",
    :association_foreign_key => "container_id"	

    # All Products that do not belong to any container
  scope :roots, -> {where("not exists (select * from children_containers where child_id=line_items.id)")}

  # All Products that have no children
  scope :subitems, -> {where("not exists (select * from children_containers where container_id=line_items.id)")}

	validates :product, presence: true
	validates :quantity, presence: true

	accepts_nested_attributes_for :product

	before_save :calculate_price

	def has_subitems?
    self.children.any?
  end

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