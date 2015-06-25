require 'fox16/calendar'
require 'line_items_table'

class LineItemDialog < FXDialogBox 
	attr_accessor :quantity
	attr_accessor :weight
	attr_accessor :product
	
	def initialize(owner)
		super(owner, "New Line Item", DECOR_TITLE|DECOR_BORDER|DECOR_RESIZE|LAYOUT_FILL_X) 

		@quantity = 0
		@weight = 0
		@product = nil

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
	    price_frame = FXHorizontalFrame.new( form, :opts => LAYOUT_FILL_X )

	    quantity_button = FXButton.new( quantity_frame, "Add quantity" )
	    quantity_label = FXLabel.new( quantity_frame, "x0", :opts => LAYOUT_FILL_X )
	    quantity_label.justify = JUSTIFY_RIGHT

	    weight_button = FXButton.new( weight_frame, "Add weight" )
	    weight_label = FXLabel.new( weight_frame, "0 Kg", :opts => LAYOUT_FILL_X )
	    weight_label.justify = JUSTIFY_RIGHT

	    quantity_button.connect(SEL_COMMAND) do |sender, sel, data|
	    	@quantity = FXInputDialog.getInteger(0, self, 
	    		"Quantity", "Quantity", nil, 0, 1000)

	    	quantity_label.text = @quantity.to_s
	    end

	    weight_button.connect(SEL_COMMAND) do |sender, sel, data|
	    	@weight = FXInputDialog.getReal(0, self, 
	    		"Weight", "Weight", nil, 0, 1000)

	    	weight_label.text = @weight.to_s 
	    end

	    product_label = FXLabel.new( product_frame, "Product:", :opts => LAYOUT_FILL_X )
	    product_label.justify = JUSTIFY_LEFT
	    # Attributes for FXComboBox.new
	    # cols, target=nil, selector=0, opts=COMBOBOX_NORMAL, x=0, y=0, 
		# width=0, height = 0, padLeft = DEFAULT_PAD, padRight = DEFAULT_PAD, 
		# padTop = DEFAULT_PAD, padBottom = DEFAULT_PAD
		product_combo_box = FXComboBox.new(product_frame, 
			20, nil, 0, LAYOUT_FILL_X, 20, 20 ) 

		price_label = FXLabel.new( product_frame, "Price:", :opts => LAYOUT_FILL_X )
	    price_label.justify = JUSTIFY_RIGHT

	    iva_label = FXLabel.new( product_frame, "IVA:", :opts => LAYOUT_FILL_X )
	    iva_label.justify = JUSTIFY_RIGHT

	    Product.all.each do | product |
	    	product_combo_box.appendItem( product.name, product )
	    end

	    product_combo_box.connect(SEL_COMMAND) do |sender, sel, text|
	    	index = sender.findItem(text)
	    	@product = sender.getItemData( index )
	    	price_label.text = "Price: #{@product.price} EUR"
	    	iva_label.text = "IVA: #{@product.taxes} %"
	    end 

	    # This needs to be after the connection above
	    # otherwise @product = nil although current product in combobox is not nil
	    product_combo_box.setCurrentItem(1, true)
	    product_combo_box.editable = false 
	    #product_combo_box.numVisible( 5 ) # not working
	end

	def is_data_filled?
		if @quantity > 0 && @weight > 0 && @product
			true
		else
			false
		end
	end
end
