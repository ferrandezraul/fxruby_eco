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

	    h_frame = FXHorizontalFrame.new( form, :opts => LAYOUT_FILL_X )

	    #FXLabel.new( h_frame, "Quantity" )
	    #@line_item[:quantity].value = FXInputDialog.getInteger(0, self, "Quantity", "Quantity").to_s

	    # FXMessageBox.warning( form, MBOX_OK, "TODO line_item_dialog", "TODO line_item_dialog")  
	end

	def is_data_filled?
		# TODO
		true
	end
end
