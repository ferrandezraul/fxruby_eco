require 'orders_table'
require 'order_dialog'

include Fox

class OrdersView < FXPacker
  
  def initialize(parent, orders)
    super(parent, :opts => LAYOUT_FILL)

    # button to add a new product
    button_new_order = FXButton.new( self, "Add new order", :opts => BUTTON_NORMAL)
	button_new_order.connect(SEL_COMMAND) do |sender, sel, data| 
		# Show dialog for entering data
		order_dialog = OrderDialog.new( self )
		if order_dialog.execute != 0
		    date = order_dialog.order[:date]
		    customer_name = order_dialog.order[:customer].name
		    
		    # customer = Order.create!( :name => name,
      #                                 :address => address,
      #                                 :nif => nif,
      #                                 :customer_type => tipo )
			puts "Customer selected #{customer_name}"
			puts "Date selected #{date}"
		    # @table.add_customer( customer )
	    end
	end

    @table = OrdersTable.new( self, orders )

  end

  def reset( orders )
  	@table.reset( orders )
  end

end