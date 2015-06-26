class ProductDialog < FXDialogBox 
	attr_accessor :product
	
	def initialize(owner)
		super(owner, "New Product", DECOR_TITLE|DECOR_BORDER|DECOR_RESIZE, 0, 0, 500) 

		@product = {
	      :name => FXDataTarget.new,
	      :price => FXDataTarget.new,
	      :taxes => FXDataTarget.new
	    }

	    # Initialize FXDataTarget
	    # Needed in order to catch changes from GUI
	    @product[:name].value = String.new
	    @product[:price].value = String.new
	    @product[:taxes].value = String.new

	    construct_product_page
		add_terminating_buttons
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
			 if !is_name_valid?
			 	FXMessageBox.warning( self, MBOX_OK, 
			 		"There is already a product with this name",
			 		"There is already a product with this name" )
			 else
		     	self.handle(sender, FXSEL(SEL_COMMAND, FXDialogBox::ID_ACCEPT), nil)
		     end
		end
	end

	def construct_product_page	    
	    form = FXMatrix.new( self, 2, :opts => MATRIX_BY_COLUMNS|LAYOUT_FILL_X )
	    
	    FXLabel.new( form, "Name:")
	    name = FXTextField.new(form, 20, :target => @product[:name], :selector => FXDataTarget::ID_VALUE,
	      :opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)

	    FXLabel.new(form, "Price:")
	    price = FXTextField.new(form, 20, 
	    	:target => @product[:price], 
	    	:selector => FXDataTarget::ID_VALUE, 
	    	:opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)
	    price.text = "Press any key and enter price ..."

	    price.connect(SEL_KEYPRESS) do |sender, sel, data|
	    	precio = FXInputDialog.getReal(0, self, 
	    		"Price", "Price", nil, 0, 1000)
	    	@product[:price].value = precio.to_s
	    	sender.text = "#{precio.to_s} EUR"
	    end

	    FXLabel.new(form, "IVA:")
	    tax = FXTextField.new(form, 20, 
	    	:target => @product[:taxes], 
	    	:selector => FXDataTarget::ID_VALUE, 
	    	:opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)
	    tax.text = "Press any key and enter IVA ..."

	    tax.connect(SEL_KEYPRESS) do |sender, sel, data|
	    	taxes = FXInputDialog.getReal(0, self, 
	    		"IVA", "IVA", nil, 0, 20)
	    	@product[:taxes].value = taxes.to_s
	    	sender.text = "#{taxes.to_s} %"
	    end
	 end

	 def is_data_filled?
	 	( @product[:name].value.length > 0 ) \
	 	&& ( @product[:price].value.length > 0 ) \
	 	&& ( @product[:taxes].value.length > 0 )
	 end

	 def is_name_valid?
	 	!Product.exists?( :name => @product[:name].value )
	 end
end
