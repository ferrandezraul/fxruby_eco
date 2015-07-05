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

    delete_product = FXButton.new( self, 
      "Delete product", :opts => BUTTON_NORMAL)
    
	  button_new_product.connect(SEL_COMMAND, method(:on_add_product) )
    delete_product.connect(SEL_COMMAND, method(:on_delete_product) )

    @table = ProductsTable.new( self )
  end

  def on_add_product( sender, sel, data )
  	product_dialog = ProductDialog.new( self )
	  if product_dialog.execute != 0
	    @table.add_product( product_dialog.product )
    end
  end

  def on_delete_product( sender, sel, data )
    product = @table.current_product
    if product
      delete_product product
      @table.reset
    else
      FXMessageBox.warning( self, MBOX_OK, "Select a product from table", 
        "Select a product from table and press again." )
    end
  end

  def delete_product( product )
    answer = FXMessageBox.question( self,
                                    MBOX_YES_NO,
                                    "Just one question...", "Do you want to delete #{product.name}?" )
    if answer == MBOX_CLICKED_YES
      product.destroy!
    end
  end

  def reset
    @table.reset
  end

end