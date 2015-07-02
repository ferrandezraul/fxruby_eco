require 'orders_table'
require 'order_dialog'
require 'date_dialog'

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
  	order_dialog = OrderDialog.new( self, get_date )
		if order_dialog.execute != 0
        @table.reset
    end
  end

  def get_date
  	date_dialog = DateDialog.new(self)
	if date_dialog.execute != 0
	  	date_dialog.date
	end
  end

  def reset
  	@table.reset
  end

end