include Fox

class CustomersTable < FXTable
  attr_reader :customer

  COLUMN_ID = 0
  COLUMN_NAME = 1
  COLUMN_ADDRESS = 2
  COLUMN_NIF = 3
  COLUMN_CUSTOMER_TYPE = 4
  NUM_COLUMNS = 5
  
  def initialize(parent)
    super(parent, :opts => TABLE_COL_SIZABLE|TABLE_ROW_SIZABLE|LAYOUT_FILL_X|LAYOUT_FILL_Y)

    fill_table( Customer.all)

    self.connect(SEL_REPLACED, method(:on_cell_changed))
    self.connect(SEL_DOUBLECLICKED, method(:on_cell_double_clicled))
  end

  def fill_table(customers)
    #setColumnHeaderMode = LAYOUT_FILL_X
    #rowHeaderMode = LAYOUT_FILL_X

    setTableSize(0, NUM_COLUMNS)

    setColumnText(COLUMN_ID, "ID")
    setColumnText(COLUMN_NAME, "Name")
    setColumnText(COLUMN_ADDRESS, "Address")
    setColumnText(COLUMN_NIF, "NIF")
    setColumnText(COLUMN_CUSTOMER_TYPE, "Customer Type")

    setColumnWidth(COLUMN_ID, 50)
    setColumnWidth(COLUMN_NAME, 100)
    setColumnWidth(COLUMN_ADDRESS, 200)
    setColumnWidth(COLUMN_NIF, 200)
    setColumnWidth(COLUMN_CUSTOMER_TYPE, 200)

    columnHeader.setItemJustify(COLUMN_ID, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_NAME, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_ADDRESS, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_NIF, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_CUSTOMER_TYPE, FXHeaderItem::CENTER_X)

    customers.each do |customer|
      add_customer(customer)
    end
  end

  def add_customer(customer)
    num_rows = getNumRows
    appendRows( 1 )
    setItemText( num_rows, COLUMN_ID, customer.id.to_s )
    setItemText( num_rows, COLUMN_NAME, customer.name )
    setItemText( num_rows, COLUMN_ADDRESS, customer.address )
    setItemText( num_rows, COLUMN_NIF, customer.nif )
    setItemText( num_rows, COLUMN_CUSTOMER_TYPE, customer.customer_type )
  end

  def reset
    clearItems
    fill_table(Customer.all)
  end

  def on_cell_changed(sender, sel, table_pos)
    # table_pos fm = from
    #           to = to
    # Table has changed from cell between fm and to
    # Assume only a cell is changed
    column = table_pos.fm.col
    row = table_pos.fm.row

    case column
    when COLUMN_ID
      FXMessageBox.warning( self, MBOX_OK, "Id is not editable", "You can not edit the id!" )

      # Revert id in view
      product = Customer.find_by!( :name => getItemText( row, COLUMN_NAME ),
                                   :address => getItemText( row, COLUMN_ADDRESS ) )

      setItemText( row, COLUMN_ID, product.id.to_s )
    when COLUMN_NAME
      customer_id = getItemText( row, COLUMN_ID ).to_i
      new_name = getItemText( row, COLUMN_NAME )

      Customer.update( customer_id, :name => new_name)      
    when COLUMN_ADDRESS
      customer_id = getItemText( row, COLUMN_ID ).to_i
      new_address = getItemText( row, COLUMN_ADDRESS )
      setItemText( row, COLUMN_ADDRESS, new_address )

      Customer.update( customer_id, :address => new_address ) 
    when COLUMN_NIF
      customer_id = getItemText( row, COLUMN_ID ).to_i
      new_nif = getItemText( row, COLUMN_NIF )
      setItemText( row, COLUMN_NIF, new_nif )

      Customer.update( customer_id, :nif => new_nif )
    when COLUMN_CUSTOMER_TYPE
      customer_id = getItemText( row, COLUMN_ID ).to_i
      new_type = getItemText( row, COLUMN_CUSTOMER_TYPE )

      if ( ( new_type != Customer::Type::COOPERATIVA ) && ( new_type != Customer::Type::TIENDA ) && ( new_type != Customer::Type::CLIENTE ) )
        FXMessageBox.warning( self, MBOX_OK, "Invalid customer type",
          "Invalid customer type. Use #{Customer::Type::COOPERATIVA}, #{Customer::Type::TIENDA} or #{Customer::Type::CLIENTE}" )
        # Revert change in view
        setItemText( row, COLUMN_CUSTOMER_TYPE, Customer.find_by!( :id => getItemText( row, COLUMN_ID ) ).customer_type )
      else
        setItemText( row, COLUMN_CUSTOMER_TYPE, new_type )
        Customer.update( customer_id, :customer_type => new_type )
      end
    else
      puts "You gave me #{column} -- I have no idea what to do with that."
    end    
    #puts product.to_json if product

  end

  def on_cell_double_clicled( sender, sel, table_pos)
    row = table_pos.row
    customer = Customer.find_by!( :id => getItemText( row, COLUMN_ID ) )

    delete_customer?( row, customer )
  end

  def delete_customer?( row, customer )
    answer = FXMessageBox.question( self,
                                    MBOX_YES_NO,
                                    "Just one question...", "Do you want to delete #{customer.name}?" )
    if answer == MBOX_CLICKED_YES
      customer.destroy
      removeRows( row ) # Removes one row by default
    end
  end

  def create
    super
    show()
  end

end