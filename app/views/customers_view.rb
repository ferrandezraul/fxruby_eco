require 'customers_table'
require 'customers_dialog'

include Fox

class CustomersView < FXPacker
  
  def initialize(parent, customers)
    super(parent, :opts => LAYOUT_FILL)

    # button to add a new product
    button_new_customer = FXButton.new( self, "Add new customer", :opts => BUTTON_NORMAL)
	button_new_customer.connect(SEL_COMMAND) do |sender, sel, data| 
		# Show dialog for entering data
		customer_dialog = CustomerDialog.new( self )
		if customer_dialog.execute != 0
		    name = customer_dialog.customer[:name].value
		    address = customer_dialog.customer[:address].value
		    nif = customer_dialog.customer[:nif].value
		    tipo = customer_dialog.customer[:type].value

		    customer = Customer.create!( :name => name,
	                                     :address => address,
	                                     :nif => nif,
	                                     :customer_type => tipo )

		    @table.add_customer( customer )
	    end
	end

    @table = CustomersTable.new( self, customers )

  end

  def reset( customers )
  	@table.reset( customers )
  end

end