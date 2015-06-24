require 'fox16/calendar'
require 'line_items_table'
require 'line_item_dialog'

class OrderDialog < FXDialogBox 
	attr_accessor :order
	
	def initialize(owner)
		super(owner, "New Order", DECOR_TITLE|DECOR_BORDER|DECOR_RESIZE|LAYOUT_FILL_X) 

		@order = {
		  :date => FXDataTarget.new,
	      :customer => FXDataTarget.new,
	      :price => FXDataTarget.new,
	      :line_items => FXDataTarget.new
	    }

	    @line_items = Array.new

	    # Initialize FXDataTarget
	    # Needed in order to catch changes from GUI
	    @order[:date].value = String.new
	    @order[:customer].value = String.new
	    @order[:price].value = String.new
	    @order[:line_items].value = String.new

		add_terminating_buttons

		construct_page
	end

	def add_terminating_buttons
		buttons = FXHorizontalFrame.new(self, 
					:opts => LAYOUT_FILL_X|LAYOUT_SIDE_BOTTOM|PACK_UNIFORM_WIDTH) 

		ok_button = FXButton.new( buttons, "OK",
					  :target => self, 
					  :selector => FXDialogBox::ID_ACCEPT,
					  :opts => BUTTON_NORMAL|LAYOUT_RIGHT)

		FXButton.new( buttons, "Cancel",
					  :target => self, 
					  :selector => FXDialogBox::ID_CANCEL,
    				  :opts => BUTTON_NORMAL|LAYOUT_RIGHT)

		# Disable ok button if there are no values on order attributes
		ok_button.connect(SEL_UPDATE) do |sender, sel, data| 
			sender.enabled = is_date_filled?
		end

		# Connect signal button pressed with sending an ID_ACCEPT event 
		# from this FXDialogBox. Note that the cancel button is automatically tied
		# with the event ID_CANCEL from this FXDialog in the constructor of the cancel button.
		ok_button.connect(SEL_COMMAND) do |sender, sel, data|
		     self.handle(sender, FXSEL(SEL_COMMAND, FXDialogBox::ID_ACCEPT), nil)
		end
	end

	def construct_page    
	    form = FXVerticalFrame.new( self, :opts => LAYOUT_FILL)

	    construct_date_form( form )
	    construct_customer_form( form )
	    construct_line_items_form( form )    
	end

	def construct_date_form(matrix)
		date_form = FXHorizontalFrame.new( matrix, :opts => LAYOUT_FILL_X )
	    
	    FXLabel.new( date_form, "Date:")
	    date = FXTextField.new( date_form, 30,
	      :opts => TEXTFIELD_NORMAL)
	    date.text = "Select a day from calendar"

    	@calendar = FXCalendar.new(date_form)
    	@calendar.connect(SEL_COMMAND) do |calendar, sel, time|
    		@order[:date].value = time.strftime("%d/%m/%Y") 
    		date.text = time.strftime("%d/%m/%Y") 
    	end
    end

    def construct_customer_form(matrix)
    	customer_form = FXHorizontalFrame.new( matrix, :opts => LAYOUT_FILL_X )
	    
    	FXLabel.new( customer_form, "Customer:" )
	    customer_combo_box = FXComboBox.new(customer_form, 20, 
	      :target => @order[:customer], :selector => FXDataTarget::ID_VALUE,
	      :opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X)

	    Customer.all.each do | customer |
	    	customer_combo_box.appendItem( customer.name )
	    end

	    customer_combo_box.editable = false 
	    customer_combo_box.setCurrentItem(1, true)
	end

	def construct_line_items_form(matrix)
		add_item_button = FXButton.new( matrix, "Add Line Item", :opts => BUTTON_NORMAL)
	    add_item_button.connect( SEL_COMMAND) do |sender, sel, data|
	    	# TODO create LineItem dialog
	    	line_item_dialog = LineItemDialog.new(self)
	    	if line_item_dialog.execute != 0
	    		item = line_item_dialog.line_item
	    		puts "Weight is #{item[:quantity].value}"
	    		puts "Product is #{item[:product].value}"
	    		puts "Price is #{item[:price].value}"

	    		# p = LineItem.new( :quantity => item[:quantity],
	    		# 				  :weight => item[:weight],
	    		# 				  :product => Product.find_by!( :name => item[:product] ),
	    		# 				  :price => item[:price] )

	    		# @line_items << p
	    		# @line_items_table.add( p )
	    	end	    	
	    end

	    # TODO line items table
	    @line_items_table = LineItemsTable.new( matrix, @line_items )	
	end

	def is_date_filled?
	 	!@order[:date].value.empty?
	end
end
