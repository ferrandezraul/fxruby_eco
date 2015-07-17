require 'orders_table'
require 'order_dialog'
require 'date_dialog'
require 'customer_picker_dialog'

require 'ap'

include Fox

class OrdersView < FXPacker
  
  def initialize(parent)
    super(parent, :opts => LAYOUT_FILL)

    button_new_order = FXButton.new( self, "Add new order", :opts => BUTTON_NORMAL)
    button_delete_order = FXButton.new( self, "Delete order", :opts => BUTTON_NORMAL)

    button_new_order.connect(SEL_COMMAND, method(:get_new_order) )
    button_delete_order.connect(SEL_COMMAND, method(:on_delete_order) )

    @table = OrdersTable.new( self )
  end

  def on_delete_order( sender, sel, data )
    order = @table.current_order
    if order
      delete_order order
      @table.reset
    else
      FXMessageBox.warning( self, MBOX_OK, "Select an order from table", 
        "Select an order from table and press again." )
    end
  end

  def delete_order( order )
    answer = FXMessageBox.question( self,
                                    MBOX_YES_NO,
                                    "Just one question...", "Do you want to delete this order from #{order.customer.name}?" )
    if answer == MBOX_CLICKED_YES
      order.destroy!
    end
  end

  def get_new_order( sender, sel, data )
  	date = get_date

  	if date
  		customer = get_customer
  		if customer
  			order_dialog = OrderDialog.new( self, date, customer )
        if order_dialog.execute != 0
		        @table.reset
		    end
  		end
  	end
  end

  def get_date
  	date_dialog = DateDialog.new(self)
    if date_dialog.execute != 0
	  	date_dialog.date
    else
      nil
    end
  end

  def get_customer
  	dialog = CustomerPickerDialog.new(self)
    if dialog.execute != 0
	  	dialog.customer
    else
  	    nil
    end
  end

  def reset
  	@table.reset
  end

end