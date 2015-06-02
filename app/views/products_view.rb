require 'products_table'

include Fox

class ProductsView < FXPacker
  attr_reader :product
  
  def initialize(parent, products)
    super(parent, :opts => LAYOUT_FILL)

    FXLabel.new(self, "Table of products:")
    ProductsTable.new( self, products )

  end

end