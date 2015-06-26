require 'fox16/calendar'
require 'line_items_table'

class LineItemDialog < FXDialogBox 
	attr_accessor :item
	
	def initialize(owner)
		super(owner, "New Line Item", DECOR_TITLE|DECOR_BORDER|DECOR_RESIZE|LAYOUT_FILL_X) 

		@item = {
	      :quantity => FXDataTarget.new,
	      :weight => FXDataTarget.new,
	      :product => nil
	    }

	    # Initialize FXDataTarget
	    # Needed in order to catch changes from GUI
	    @item[:quantity].value = String.new
	    @item[:weight].value = String.new

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
	    matrix = FXMatrix.new( form, 2, :opts => MATRIX_BY_COLUMNS|LAYOUT_FILL_X )

	    product_frame = FXHorizontalFrame.new( form, :opts => LAYOUT_FILL_X )
	    price_frame = FXHorizontalFrame.new( form, :opts => LAYOUT_FILL_X )
	    
	    FXLabel.new( matrix, "Quantity:" )
	    FXTextField.new(matrix, 20, :target => @item[:quantity], :selector => FXDataTarget::ID_VALUE,
	      :opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)

	    FXLabel.new( matrix, "Weight:" )
	    FXTextField.new(matrix, 20, :target => @item[:weight], :selector => FXDataTarget::ID_VALUE,
	      :opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)

	    product_label = FXLabel.new( product_frame, "Product:" )
	    product_label.justify = JUSTIFY_LEFT
	    # Attributes for FXComboBox.new
	    # cols, target=nil, selector=0, opts=COMBOBOX_NORMAL, x=0, y=0, 
		# width=0, height = 0, padLeft = DEFAULT_PAD, padRight = DEFAULT_PAD, 
		# padTop = DEFAULT_PAD, padBottom = DEFAULT_PAD
		product_combo_box = FXComboBox.new(product_frame, 
			20, nil, 0, LAYOUT_FILL_Y, 20, 20 ) 

		price_label = FXLabel.new( product_frame, "Price:", :opts => LAYOUT_FILL_X )
	    price_label.justify = JUSTIFY_RIGHT

	    iva_label = FXLabel.new( product_frame, "IVA:", :opts => LAYOUT_FILL_X )
	    iva_label.justify = JUSTIFY_RIGHT

	    Product.all.each do | product |
	    	product_combo_box.appendItem( product.name, product )
	    end

	    product_combo_box.connect(SEL_COMMAND) do |sender, sel, text|
	    	index = sender.findItem(text)
	    	product = sender.getItemData( index )
	    	price_label.text = "Price: #{product.price} EUR"
	    	iva_label.text = "IVA: #{product.taxes} %"
	    	@item[:product] = product
	    end 

	    # This needs to be after the connection above
	    # otherwise @item[:product] = nil although current product in combobox is not nil
	    product_combo_box.setCurrentItem(1, true) if Product.count > 0
	    product_combo_box.editable = false 
	    #product_combo_box.numVisible( 5 ) # not working
	end

	def is_data_filled?
		@item[:quantity].value =~ /\A[0-9]*\Z/ \
		&& @item[:weight].value =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/ && @item[:product]
	end
end
