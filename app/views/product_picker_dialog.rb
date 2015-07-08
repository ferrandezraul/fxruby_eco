class ProductPickerDialog < FXDialogBox
  attr_accessor :product

  def initialize(parent)
	super(parent, "Choose product", DECOR_TITLE|DECOR_BORDER|DECOR_RESIZE|LAYOUT_FILL_X) 

	construct_page
  	add_terminating_buttons
  end

  def construct_page
  	form = FXHorizontalFrame.new( self, :opts => LAYOUT_FILL )
    
  	FXLabel.new( form, "Product:" )
    product_combo_box = FXComboBox.new(form, 20, 
      :opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X)

    Product.all.each do | product |
    	product_combo_box.appendItem( product.name, product )
    end

    product_combo_box.connect(SEL_COMMAND) do |sender, sel, text|
    	index = sender.findItem(text)
    	@product = sender.getItemData( index ) 
    end

    product_combo_box.editable = false 
    product_combo_box.setCurrentItem(1, true) if Customer.count > 0
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
			sender.enabled = !@product.nil?
		end

		# Connect signal button pressed with sending an ID_ACCEPT event 
		# from this FXDialogBox. Note that the cancel button is automatically tied
		# with the event ID_CANCEL from this FXDialog in the constructor of the cancel button.
		ok_button.connect(SEL_COMMAND) do |sender, sel, data|
		    self.handle(sender, FXSEL(SEL_COMMAND, FXDialogBox::ID_ACCEPT), nil)
		end
	end

end
