require 'active_record'

class Product < ActiveRecord::Base
	has_one :line_item  # Each product has many line_items referencing it.
										  # Each line_item contains a reference to its product id			

  # A product might contain subproducts
  # This is an implementation of the composite design pattern
  # See http://stackoverflow.com/questions/17603142/implementing-the-composite-pattern-in-ruby-on-rails
	has_and_belongs_to_many :children,
    :class_name => "Product",
    :join_table => "children_containers",
    :foreign_key => "container_id",
    :association_foreign_key => "child_id"

  has_and_belongs_to_many :containers,
    :class_name => "Product",
    :join_table => "children_containers",
    :foreign_key => "child_id",
    :association_foreign_key => "container_id"				  

	validates :name, presence: true, uniqueness: true
	validates :price, presence: true
	validates :price_type, presence: true    # por_unidad o por_kilo
	validates :tax_percentage, presence: true

	before_save :calculate
	before_destroy :check_for_line_item

	# All Products that do not belong to any container
  scope :roots, -> {where("not exists (select * from children_containers where child_id=products.id)")}

  # All Products that have no children
  scope :subproducts, -> {where("not exists (select * from children_containers where container_id=products.id)")}

  module PriceType
	    POR_KILO      = "por_kilo"
	    POR_UNIDAD    = "por_unidad"
	end

  # Is this Component at root level
  def root?
    self.containers.empty?
  end

  # Is this Component at leaf level
  def leaf?
    self.children.empty?
  end

  def has_subproducts?
    self.children.any?
  end

  # Notice the recursive call to traverse the Component hierarchy
  #   Similarly, it can be written to output using nested <ul> and <li>s as well.
  def to_s(level=0)
    "#{'  ' * level}#{name}\n" + children.map {|c| c.to_s(level + 1)}.join
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
