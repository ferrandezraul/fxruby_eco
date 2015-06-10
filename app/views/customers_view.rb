require 'customers_table'

include Fox

class CustomersView < FXPacker
  attr_reader :customer
  
  def initialize(parent, customers)
    super(parent, :opts => LAYOUT_FILL)

    # button to add a new product
    button_new_customer = FXButton.new( self, "Add new customer", :opts => BUTTON_NORMAL)
	button_new_customer.connect(SEL_COMMAND) do |sender, sel, data| 
		# Show dialog for entering data
		FXMessageBox.warning( self, 
							  MBOX_OK, 
							  "Create new customer dialog", 
							  "Coming soon ...!" )
	end

    CustomersTable.new( self, customers )

  end

end