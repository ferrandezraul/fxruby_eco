class CustomerDialog < FXDialogBox 
	attr_accessor :customer
	
	def initialize(owner)
		super(owner, "New Customer", DECOR_TITLE|DECOR_BORDER|DECOR_RESIZE) 

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

		# Disable ok button if there are no values on product attributes
		# or price is not valid
		ok_button.connect(SEL_UPDATE) do |sender, sel, data| 
			sender.enabled = is_data_filled? && is_name_valid?
		end

		# Connect signal button pressed with sending an ID_ACCEPT event 
		# from this FXDialogBox. Note that the cancel button is automatically tied
		# with the event ID_CANCEL from this FXDialog in the constructor of the cancel button.
		ok_button.connect(SEL_COMMAND) do |sender, sel, data|
		     self.handle(sender, FXSEL(SEL_COMMAND, FXDialogBox::ID_ACCEPT), nil)
		end
	end

	def construct_page	    
	    @customer = {
	      :name => FXDataTarget.new,
	      :address => FXDataTarget.new,
	      :nif => FXDataTarget.new,
	      :type => FXDataTarget.new
	    }

	    # Initialize FXDataTarget
	    # Needed in order to catch changes from GUI
	    @customer[:name].value = String.new
	    @customer[:address].value = String.new
	    @customer[:nif].value = String.new
	    @customer[:type].value = String.new

	    form = FXMatrix.new( self, 2, :opts => MATRIX_BY_COLUMNS|LAYOUT_FILL_X )

	    FXLabel.new( form, "Name:")
	    FXTextField.new(form, 20, :target => @customer[:name], :selector => FXDataTarget::ID_VALUE,
	      :opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)

	    FXLabel.new(form, "Address:")
	    FXTextField.new(form, 20, :target => @customer[:address], :selector => FXDataTarget::ID_VALUE,
	      :opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)

	    FXLabel.new(form, "N.I.F.:")
	    FXTextField.new(form, 20, :target => @customer[:nif], :selector => FXDataTarget::ID_VALUE,
	      :opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)

	    FXLabel.new(form, "Type:")
	    combo_box = FXComboBox.new(form, 20, :target => @customer[:type], :selector => FXDataTarget::ID_VALUE,
	      :opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)

	    combo_box.appendItem( Customer::Type::COOPERATIVA )
	    combo_box.appendItem( Customer::Type::TIENDA )
	    combo_box.appendItem( Customer::Type::CLIENTE )

	    combo_box.editable = false
	    combo_box.setCurrentItem(1, true)
	 end

	 def is_data_filled?
	 	( @customer[:name].value.length > 0 ) && ( @customer[:address].value.length > 0 ) && ( @customer[:nif].value.length > 0 ) && ( @customer[:type].value.length > 0 )
	 end

	 def is_name_valid?
	 	!Customer.exists?( :name => @customer[:name].value )
	 end
end
