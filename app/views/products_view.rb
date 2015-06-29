require 'products_table'
require 'product_dialog'

include Fox

class ProductsView < FXPacker
  attr_reader :product
  
  def initialize(parent)
    super(parent, :opts => LAYOUT_FILL_X|LAYOUT_FILL_Y)

    # button to add a new product
    button_new_product = FXButton.new( self, 
      "Add new product", :opts => BUTTON_NORMAL)
    
	  button_new_product.connect(SEL_COMMAND, method(:on_add_product) )

    @table = ProductsTable.new( self )
  end

  def on_add_product( sender, sel, data )
  	product_dialog = ProductDialog.new( self )
	  if product_dialog.execute != 0
	    @table.add_product( product_dialog.product )
    end
  end

  def reset
    @table.reset
  end

end