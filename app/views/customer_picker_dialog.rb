class CustomerPickerDialog < FXDialogBox
	attr_accessor :customer

	def initialize(parent)
		super(parent, "Choose custumer", DECOR_TITLE|DECOR_BORDER|DECOR_RESIZE|LAYOUT_FILL_X) 

		construct_page
    	add_terminating_buttons
    end

    def construct_page
    	customer_form = FXHorizontalFrame.new( self, :opts => LAYOUT_FILL )
	    
    	FXLabel.new( customer_form, "Customer:" )
	    customer_combo_box = FXComboBox.new(customer_form, 20, 
	      :opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X)

	    Customer.all.each do | customer |
	    	customer_combo_box.appendItem( customer.name, customer )
	    end

	    customer_combo_box.connect(SEL_COMMAND) do |sender, sel, text|
	    	index = sender.findItem(text)
	    	@customer = sender.getItemData( index ) 
	    end

	    customer_combo_box.editable = false 
	    customer_combo_box.setCurrentItem(1, true) if Customer.count > 0
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
			sender.enabled = !@customer.nil?
		end

		# Connect signal button pressed with sending an ID_ACCEPT event 
		# from this FXDialogBox. Note that the cancel button is automatically tied
		# with the event ID_CANCEL from this FXDialog in the constructor of the cancel button.
		ok_button.connect(SEL_COMMAND) do |sender, sel, data|
		    self.handle(sender, FXSEL(SEL_COMMAND, FXDialogBox::ID_ACCEPT), nil)
		end
	end

end
