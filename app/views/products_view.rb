require 'products_table'

include Fox

class ProductsView < FXPacker
  attr_reader :product
  
  def initialize(parent, products)
    super(parent, :opts => LAYOUT_FILL)

    # button to add a new product
    button_new_product = FXButton.new( self, "Add new product", :opts => BUTTON_NORMAL|LAYOUT_CENTER_X)
	button_new_product.connect(SEL_COMMAND) do |sender, sel, data| 
		# Show dialog for entering data
		FXMessageBox.warning( self, 
							  MBOX_OK, 
							  "Create new product dialog", 
							  "Coming soon ...!" )
	end

    ProductsTable.new( self, products )

  end

end