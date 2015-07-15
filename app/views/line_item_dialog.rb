require 'fox16/calendar'
require 'line_items_table'

class LineItemDialog < FXDialogBox 
	attr_accessor :item
	
	def initialize(owner, order)
		super(owner, "New Line Item", DECOR_TITLE|DECOR_BORDER|DECOR_RESIZE|LAYOUT_FILL_X) 

		@order = order
		@item = { :quantity => 0,
				  :weight => 0,
				  :product => nil }

		construct_page
		add_terminating_buttons
	end

	def construct_quantity(matrix)
		FXLabel.new( matrix, "Quantity:" )
	  quantity = FXTextField.new(matrix, 20, 
	      :opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)
	  quantity.text = "Press any key and enter quantity ..."

	  quantity.connect(SEL_KEYPRESS) do |sender, sel, data|
	  	cantidad = FXInputDialog.getInteger(0, self, 
	    	"Quantity", "Quantity", nil, 1, 1000)
	  	@item[:quantity] = cantidad
	  	sender.text = "#{cantidad.to_s}"
		end
	end

	def construct_weight(matrix)
	  FXLabel.new( matrix, "Weight:" )
	  @weight_field = FXTextField.new(matrix, 20, 
	      :opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X|LAYOUT_FILL_COLUMN)
	  @weight_field.text = "Press any key and enter weight in kg ..."
	    
	  @weight_field.connect(SEL_KEYPRESS) do |sender, sel, data|
	  	peso = FXInputDialog.getReal(0, self, 
	  		"Weight", "Weight", nil, 0, 1000)
	  	@item[:weight] = peso
	  	sender.text = "#{peso.to_s} Kg"
	  end
	  @weight_field.enabled = false
	end

	def construct_product_info(frame)
		@price_label = FXLabel.new( frame, "Price:", :opts => LAYOUT_FILL_X )
	  @price_label.justify = JUSTIFY_RIGHT

	  @iva_label = FXLabel.new( frame, "IVA:", :opts => LAYOUT_FILL_X )
	  @iva_label.justify = JUSTIFY_RIGHT

    @total_label = FXLabel.new( frame, "Total:", :opts => LAYOUT_FILL_X )
	  @total_label.justify = JUSTIFY_RIGHT
	end

	def construct_product(form)
		product_frame = FXHorizontalFrame.new( form, :opts => LAYOUT_FILL_X )
	  price_frame = FXHorizontalFrame.new( form, :opts => LAYOUT_FILL_X )

	  FXLabel.new( product_frame, "Product:" )
		@product_combo_box = FXComboBox.new(product_frame, 
			20, nil, 0, LAYOUT_FILL_Y, 20, 20 ) 

		construct_product_info(product_frame)
		
	  Product.all.where( :outdated => false ).each do | product |
	    	@product_combo_box.appendItem( product.name, product )
	  end

	  @product_combo_box.connect(SEL_COMMAND) do |sender, sel, text|
	  	index = sender.findItem(text)
	   	product = sender.getItemData( index )
	   	raise Exception.new("product can not be nil") if product.nil? 

	   	on_new_product_selected(product)
	  end

	  # This needs to be after the connection above
	  # otherwise @item[:product] = nil although current product in combobox is not nil
	  @product_combo_box.setCurrentItem(1, true) if Product.count > 0
	  @product_combo_box.editable = false   	 	
	  #@product_combo_box.numVisible( 5 ) # not working
	end


	def construct_page
		form = FXVerticalFrame.new( self, :opts => LAYOUT_FILL)
		matrix = FXMatrix.new( form, 2, :opts => MATRIX_BY_COLUMNS|LAYOUT_FILL_X )
	    
	  construct_quantity(matrix)
		construct_weight(matrix)
		construct_product(form)
	end

	def on_new_product_selected(product)
		@weight_field.enabled = ( product.price_type == Product::PriceType::POR_KILO )
	  @price_label.text = "Price: #{product.price} EUR"
	  @iva_label.text = "IVA: #{product.tax_percentage} %"
	  @total_label.text = "Total: #{product.total} EUR"
	  @item[:product] = product
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
			@order.save! # Need to have order in database before creating line_items on database
			parent_item = @order.line_items.create!( item )	
			if item[:product].has_subproducts?
				FXMessageBox.warning( self, MBOX_OK, "Now select subproducts", "Now select subproducts" )
				items = Array.new
				item[:product].children.each do |subproduct|
					peso = 0
					cantidad = FXInputDialog.getInteger(0, self, "Select quantity for #{subproduct.name}",
					 "Select quantity for #{subproduct.name}", nil, 1, 100)
					if subproduct.price_type == Product::PriceType::POR_KILO
					 	peso = FXInputDialog.getReal(0, self, "Select weight in kg for #{subproduct.name}", 
					 		"Select weight in kg for #{subproduct.name}", nil, 0, 100)
					end
					items << LineItem.new( :order => @order,
																 :product => subproduct,
                                 :quantity => cantidad,
                                 :weight => peso )
				end

				parent_item.subitems << items
			end

			self.handle(sender, FXSEL(SEL_COMMAND, FXDialogBox::ID_ACCEPT), nil)
		end
	end

	def is_data_filled?
		if @item[:product] && @item[:product].valid?
			if @item[:product].price_type == Product::PriceType::POR_KILO
				@item[:quantity] > 0 && @item[:weight] > 0
			else
				@item[:quantity] > 0
			end
		else
			false
		end
	end
end
