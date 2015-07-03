class CustomerDialog < FXDialogBox 
	attr_accessor :customer
	
	def initialize(owner)
		super(owner, "New Customer", DECOR_TITLE|DECOR_BORDER|DECOR_RESIZE) 

		@customer = Customer.new

		add_terminating_buttons
		construct_page
	end

	def add_terminating_buttons
		buttons = FXHorizontalFrame.new(self, 
					:opts => LAYOUT_FILL_X|LAYOUT_SIDE_BOTTOM|PACK_UNIFORM_WIDTH) 

		# Taking advantage of the fact that the FXDialogBox class from which this dialog
		# is subclassed defines two message identifiers, ID_ACCEPT and ID_CANCEL, 
		# that we can send directly from the OK and Cancel buttons to the dialog box to dismiss it.
		# If the user clicks our OK button, it will send a message of type SEL_COMMAND,
		# with identifier ID_ACCEPT, back to the dialog box object. When the dialog box receives
		# that message, it will hide itself and ensure that the call to execute that originally
		# launched the dialog box returns a nonzero value. 
		# If the dialog box receives the ID_CANCEL message instead,
		# it will ensure that execute( ) returns zero.
		ok_button = FXButton.new( buttons, "OK",
					  :target => self, 
					  :selector => FXDialogBox::ID_ACCEPT,
					  :opts => BUTTON_NORMAL|LAYOUT_RIGHT)

		FXButton.new( buttons, "Cancel",
					  :target => self, 
					  :selector => FXDialogBox::ID_CANCEL,
    				  :opts => BUTTON_NORMAL|LAYOUT_RIGHT)

		# Disable ok button if there are no valid attributes
		ok_button.connect(SEL_UPDATE) do |sender, sel, data| 
			sender.enabled = is_data_filled?
		end

		# Connect signal button pressed with sending an ID_ACCEPT event 
		# from this FXDialogBox. Note that the cancel button is automatically tied
		# with the event ID_CANCEL from this FXDialog in the constructor of the cancel button.
		ok_button.connect(SEL_COMMAND) do |sender, sel, data|
			if is_name_valid?
				  @customer.save!
		    	self.handle(sender, FXSEL(SEL_COMMAND, FXDialogBox::ID_ACCEPT), nil)
		    else
		    	FXMessageBox.warning( self, MBOX_OK, "Invalid customer name",
                    "There is already a customer with this name." )
		    end
		end
	end

	def construct_page	    
	    form = FXMatrix.new( self, 2, :opts => MATRIX_BY_COLUMNS|LAYOUT_FILL_X )

	    FXLabel.new( form, "Name:")
	    name = FXTextField.new(form, 20, 
	      :opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)
	    name.connect(SEL_COMMAND) do |sender, sel, data|
	    	@customer.name = data
	    end

	    FXLabel.new(form, "Address:")
	    address = FXTextField.new(form, 20, 
	      :opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)
	    address.connect(SEL_COMMAND) do |sender, sel, data|
	    	@customer.address = data
	    end

	    FXLabel.new(form, "N.I.F.:")
	    nif = FXTextField.new(form, 20, 
	      :opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)
	    nif.connect(SEL_COMMAND) do |sender, sel, data|
	    	@customer.nif = data
	    end

	    FXLabel.new(form, "Type:")
	    combo_box = FXComboBox.new(form, 20, 
	      :opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)

	    combo_box.appendItem( Customer::Type::COOPERATIVA )
	    combo_box.appendItem( Customer::Type::TIENDA )
	    combo_box.appendItem( Customer::Type::CLIENTE )

	    combo_box.connect(SEL_COMMAND) do |sender, sel, data|
	    	@customer.customer_type = data
	    end

	    combo_box.editable = false
	    combo_box.setCurrentItem(1, true)
	 end

	 def is_data_filled?
	 	( @customer.name ) && ( @customer.address ) && ( @customer.nif ) && ( @customer.customer_type )
	 end

	 def is_name_valid?
	 	!Customer.exists?( :name => @customer.name )
	 end
end
