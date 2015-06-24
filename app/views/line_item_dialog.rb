require 'fox16/calendar'
require 'line_items_table'

class LineItemDialog < FXDialogBox 
	attr_accessor :line_item
	
	def initialize(owner)
		super(owner, "New Line Item", DECOR_TITLE|DECOR_BORDER|DECOR_RESIZE|LAYOUT_FILL_X) 

		@line_item = {
		  :quantity => FXDataTarget.new,
	      :weight => FXDataTarget.new,
	      :product => FXDataTarget.new,
	      :price => FXDataTarget.new
	    }

	    # Initialize FXDataTarget
	    # Needed in order to catch changes from GUI
	    @line_item[:quantity].value = String.new
	    @line_item[:weight].value = String.new
	    @line_item[:product].value = String.new
	    @line_item[:price].value = String.new

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
			sender.enabled = is_data_filled?
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

	    quantity_frame = FXHorizontalFrame.new( form, :opts => LAYOUT_FILL_X )
	    weight_frame = FXHorizontalFrame.new( form, :opts => LAYOUT_FILL_X )
	    product_frame = FXHorizontalFrame.new( form, :opts => LAYOUT_FILL_X )

	    quantity_button = FXButton.new( quantity_frame, "Add quantity" )
	    quantity_label = FXLabel.new( quantity_frame, "x0", :opts => LAYOUT_FILL_X )
	    quantity_label.justify = JUSTIFY_RIGHT

	    weight_button = FXButton.new( weight_frame, "Add weight" )
	    weight_label = FXLabel.new( weight_frame, "0 Kg", :opts => LAYOUT_FILL_X )
	    weight_label.justify = JUSTIFY_RIGHT

	    quantity_button.connect(SEL_COMMAND) do |sender, sel, data|
	    	@line_item[:quantity].value = FXInputDialog.getInteger(0, self, 
	    		"Quantity", "Quantity", nil, 0, 1000).to_s

	    	quantity_label.text = @line_item[:quantity].value
	    end

	    weight_button.connect(SEL_COMMAND) do |sender, sel, data|
	    	@line_item[:weight].value = FXInputDialog.getReal(0, self, 
	    		"Weight", "Weight", nil, 0, 1000).to_s

	    	weight_label.text = @line_item[:weight].value
	    end

		product_combo_box = FXComboBox.new(product_frame, 
			20, nil, 0, LAYOUT_FILL_X, 20, 20 ) # cols, target=nil, selector=0, opts=COMBOBOX_NORMAL, x=0, y=0, 
												# width=0, height = 0, padLeft = DEFAULT_PAD, padRight = DEFAULT_PAD, padTop = DEFAULT_PAD, padBottom = DEFAULT_PAD)

	    Product.all.each do | product |
	    	product_combo_box.appendItem( product.name, product )
	    end

	    product_combo_box.editable = false 
	    product_combo_box.setCurrentItem(1, true)
	    #product_combo_box.numVisible( 5 ) # not working

	    product_combo_box.connect(SEL_COMMAND) do |sender, sel, text|
	    	index = sender.findItem(text)
	    	product = sender.getItemData( index )
	    	@line_item[:product].value = product.name # find out how FXDataTarget
	    											  # works with custom data
	    end 
	end

	def is_data_filled?
		# TODO
		true
	end
end
