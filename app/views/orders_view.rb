require 'orders_table'
require 'order_dialog'

require 'ap'

include Fox

class OrdersView < FXPacker
  
  def initialize(parent, orders)
    super(parent, :opts => LAYOUT_FILL)

    @orders = Array.new

    # button to add a new product
    button_new_order = FXButton.new( self, "Add new order", :opts => BUTTON_NORMAL)
	button_new_order.connect(SEL_COMMAND) do |sender, sel, data| 
		# Show dialog for entering data
		order_dialog = OrderDialog.new( self )
		if order_dialog.execute != 0
		    order = order_dialog.order
		    order.save!
		    ap order.to_json
		    @orders << order
		    @table.reset(@orders)
	    end
	end

    @table = OrdersTable.new( self, orders )

  end

  def reset( orders )
  	@table.reset( orders )
  end

end