require 'products_table'
require 'product_dialog'

include Fox

class ProductsView < FXPacker
  attr_reader :product
  
  def initialize(parent, products)
    super(parent, :opts => LAYOUT_FILL)

    # button to add a new product
    button_new_product = FXButton.new( self, "Add new product", :opts => BUTTON_NORMAL)
	button_new_product.connect(SEL_COMMAND) do |sender, sel, data| 

		product_dialog = ProductDialog.new( self )
		if product_dialog.execute != 0
		    name = product_dialog.product[:name].value
		    price = product_dialog.product[:price].value

		    # Show dialog for entering data
			FXMessageBox.warning( self, 
								  MBOX_OK, 
								  "Create new product", 
								  "New product #{name} with a price #{price}" )
		end
	end

    ProductsTable.new( self, products )

  end

end