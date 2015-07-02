require 'fox16/calendar'

require 'order'
require 'line_item'
require 'line_items_table'
require 'line_item_dialog'

require 'ap'

class OrderDialog < FXDialogBox 
	attr_accessor :order
	
	def initialize(owner, date, customer)
		super(owner, "New Order", DECOR_TITLE|DECOR_BORDER|DECOR_RESIZE|LAYOUT_FILL) 

	  @order = Order.new( :date => date, :customer => customer )

		construct_page
		add_terminating_buttons
	end

	def construct_page    
    form = FXVerticalFrame.new( self, :opts => LAYOUT_FILL)

    construct_header_form( form )
    construct_line_items_form( form )    
	end

  def construct_header_form(matrix)
  	form = FXHorizontalFrame.new( matrix )
  	FXLabel.new( form, "#{@order.customer.name}\n"\
  		"#{@order.customer.address}\n"\
  		"#{@order.customer.nif}\n"\
  		"#{@order.customer.customer_type}\n" ).justify = JUSTIFY_LEFT
	end

	def construct_line_items_form(matrix)
		add_item_button = FXButton.new( matrix, "Add Line Item", :opts => BUTTON_NORMAL)
	    add_item_button.connect( SEL_COMMAND) do |sender, sel, data|
	    	line_item_dialog = LineItemDialog.new(self)
	    	if line_item_dialog.execute != 0
	    		puts "Adding line item to order"
	    		puts @order.line_items.class
	    		@order.save!
	    		@order.line_items.create!( line_item_dialog.item )	    		
	    		@line_items_table.reset( @order.line_items )
	    	end	    	
	    end

	    @line_items_table = LineItemsTable.new( matrix, @order.line_items )	
	end

	def add_terminating_buttons
		buttons = FXHorizontalFrame.new(self, 
					:opts => LAYOUT_FILL_X|LAYOUT_SIDE_BOTTOM|PACK_UNIFORM_WIDTH) 

		ok_button = FXButton.new( buttons, "OK",
					  :target => self, 
					  :selector => FXDialogBox::ID_ACCEPT,
					  :opts => BUTTON_NORMAL|LAYOUT_RIGHT)

		cancel_button = FXButton.new( buttons, "Cancel",
					  :target => self, 
					  :selector => FXDialogBox::ID_CANCEL,
    				  :opts => BUTTON_NORMAL|LAYOUT_RIGHT)

		# Disable ok button if there are no values on order attributes
		ok_button.connect(SEL_UPDATE) do |sender, sel, data| 
			sender.enabled = is_data_filled?
		end

		# Connect signal button pressed with sending an ID_ACCEPT event 
		# from this FXDialogBox. Note that the cancel button is automatically tied
		# with the event ID_CANCEL from this FXDialog in the constructor of the cancel button.
		ok_button.connect(SEL_COMMAND) do |sender, sel, data|
			# TODO check order
			@order.save!
			#@order.line_items.each { |item| ap item.to_json }	
	     	self.handle(sender, FXSEL(SEL_COMMAND, FXDialogBox::ID_ACCEPT), nil)
		end

		cancel_button.connect(SEL_COMMAND) do |sender, sel, data|
			@order.destroy
	     	self.handle(sender, FXSEL(SEL_COMMAND, FXDialogBox::ID_CANCEL), nil)
		end
	end

	def is_data_filled?
	 	@order.line_items.any?
	end

end
