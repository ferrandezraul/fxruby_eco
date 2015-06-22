require 'fox16/calendar'

class OrderDialog < FXDialogBox 
	attr_accessor :order
	
	def initialize(owner)
		super(owner, "New Order", DECOR_TITLE|DECOR_BORDER|DECOR_RESIZE) 

		@order = {
		  :date => FXDataTarget.new,
	      :customer => FXDataTarget.new,
	      :price => FXDataTarget.new
	    }

	    # Initialize FXDataTarget
	    # Needed in order to catch changes from GUI
	    @order[:date].value = String.new
	    @order[:customer].value = String.new
	    @order[:price].value = String.new

		add_terminating_buttons

		construct_page( self )
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

	def construct_page(page)	    
	    form = FXMatrix.new( page, :opts => MATRIX_BY_COLUMNS)

	    construct_date_form( form )
	    construct_customer_form( form )

	    add_item_button = FXButton.new( form, "Add Line Item", :opts => BUTTON_NORMAL)
	    add_item_button.connect( SEL_COMMAND) do |sender, sel, data|
	    	# TODO create LineItem dialog
	    end	    
	end

	def construct_date_form(matrix)
		date_form = FXMatrix.new( matrix, :opts => MATRIX_BY_ROWS )
	    
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
    	FXLabel.new(matrix, "Customer:")
	    customer_combo_box = FXComboBox.new(matrix, 20, 
	      :target => @order[:customer], :selector => FXDataTarget::ID_VALUE,
	      :opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)

	    Customer.all.each do | customer |
	    	customer_combo_box.appendItem( customer.name )
	    end

	    customer_combo_box.editable = false 
	    customer_combo_box.setCurrentItem(1, true)
	end


	def is_date_filled?
	 	!@order[:date].value.empty?
	end
end
