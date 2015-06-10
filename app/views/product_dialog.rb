class ProductDialog < FXDialogBox 
	attr_accessor :product
	
	def initialize(owner)
		super(owner, "New Product", DECOR_TITLE|DECOR_BORDER|DECOR_RESIZE) 

		add_terminating_buttons

		construct_product_page( self )
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
		FXButton.new( buttons, "OK",
					  :target => self, 
					  :selector => FXDialogBox::ID_ACCEPT,
					  :opts => BUTTON_NORMAL|LAYOUT_RIGHT)

		FXButton.new( buttons, "Cancel",
					  :target => self, 
					  :selector => FXDialogBox::ID_CANCEL,
    				  :opts => BUTTON_NORMAL|LAYOUT_RIGHT)
	end

	def construct_product_page(page)
	    form = FXMatrix.new( page, 2, :opts => MATRIX_BY_COLUMNS|LAYOUT_FILL_X )

	    FXLabel.new( form, "Name:")

	    @product = {
	      :name => FXDataTarget.new,
	      :price => FXDataTarget.new
	    }

	    FXTextField.new(form, 20, :target => @product[:name], :selector => FXDataTarget::ID_VALUE,
	      :opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)

	    FXLabel.new(form, "Price:")
	    FXTextField.new(form, 20, :target => @product[:price], :selector => FXDataTarget::ID_VALUE,
	      :opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)
	  end
end