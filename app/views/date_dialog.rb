class DateDialog < FXDialogBox 
	attr_accessor :date

	def initialize(owner)
		super(owner, "Date", DECOR_TITLE|DECOR_BORDER|DECOR_RESIZE|LAYOUT_FILL_X) 

		construct_page
    	add_terminating_buttons
    end

    def construct_page
    	date_form = FXVerticalFrame.new( self, :opts => LAYOUT_FILL )
	    
	    FXLabel.new( date_form, "Date:")

	    @date_field = FXTextField.new( date_form, 30,
	      :opts => TEXTFIELD_NORMAL)

	    @date_field.text = "#{Time.now.strftime("%d/%m/%Y")}"

    	calendar = FXCalendar.new(date_form)
    	calendar.connect(SEL_COMMAND) do |sender, sel, time|
    		@date = time
    		@date_field.text = time.strftime("%d/%m/%Y") 
    	end
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
			sender.enabled = !@date_field.text.empty?
		end

		# Connect signal button pressed with sending an ID_ACCEPT event 
		# from this FXDialogBox. Note that the cancel button is automatically tied
		# with the event ID_CANCEL from this FXDialog in the constructor of the cancel button.
		ok_button.connect(SEL_COMMAND) do |sender, sel, data|
		    self.handle(sender, FXSEL(SEL_COMMAND, FXDialogBox::ID_ACCEPT), nil)
		end
	end
end