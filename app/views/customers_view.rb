require 'customers_table'
require 'customers_dialog'

include Fox

class CustomersView < FXPacker
  
  def initialize(parent)
    super(parent, :opts => LAYOUT_FILL_X|LAYOUT_FILL_Y)

    # button to add a new product
    button_new_customer = FXButton.new( self, "Add new customer", :opts => BUTTON_NORMAL)
	  button_new_customer.connect(SEL_COMMAND) do |sender, sel, data| 
		# Show dialog for entering data
		customer_dialog = CustomerDialog.new( self )
		if customer_dialog.execute != 0
		    customer = customer_dialog.customer
		    @table.add_customer( customer )
	    end
	end

    @table = CustomersTable.new( self )

  end

  def reset
  	@table.reset
  end

end