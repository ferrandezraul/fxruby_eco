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

	button_new_order.connect(SEL_COMMAND) do |sender, sel, data|
		get_new_order		
    end

    @table = OrdersTable.new( self )
  end

  def get_new_order
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