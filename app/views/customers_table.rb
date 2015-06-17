include Fox

class CustomersTable < FXTable
  attr_reader :customer

  COLUMN_ID = 0
  COLUMN_NAME = 1
  COLUMN_ADDRESS = 2
  COLUMN_NIF = 3
  COLUMN_CUSTOMER_TYPE = 4
  NUM_COLUMNS = 5
  
  def initialize(parent, customers)
    super(parent, :opts => LAYOUT_FILL|TABLE_COL_SIZABLE)

    @customers = customers

    $APPLOG.debug "Number of customers: #{@customers.count}"

    setTableSize(@customers.count, NUM_COLUMNS)

    setColumnText(COLUMN_ID, "ID")
    setColumnText(COLUMN_NAME, "Name")
    setColumnText(COLUMN_ADDRESS, "Address")
    setColumnText(COLUMN_NIF, "NIF")
    setColumnText(COLUMN_CUSTOMER_TYPE, "Customer Type")

    rowHeaderMode = ~LAYOUT_FIX_WIDTH
    columnHeader.setItemJustify(COLUMN_ID, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_NAME, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_ADDRESS, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_NIF, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_CUSTOMER_TYPE, FXHeaderItem::CENTER_X)

    @customers.each_with_index do | customer, index |
      setItemText( index, COLUMN_ID, customer.id.to_s )
      setItemText( index, COLUMN_NAME, customer.name )
      setItemText( index, COLUMN_ADDRESS, customer.address )
      setItemText( index, COLUMN_NIF, customer.nif )
      setItemText( index, COLUMN_CUSTOMER_TYPE, customer.customer_type )
    end

    self.connect(SEL_REPLACED, method(:on_cell_changed))
  end

  def add_customer( customer )
    num_rows = getNumRows
    appendRows( 1 )
    setItemText( num_rows, COLUMN_ID, customer.id.to_s )
    setItemText( num_rows, COLUMN_NAME, customer.name )
    setItemText( num_rows, COLUMN_ADDRESS, customer.address )
    setItemText( num_rows, COLUMN_NIF, customer.nif )
    setItemText( num_rows, COLUMN_CUSTOMER_TYPE, customer.customer_type )
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
    else
      puts "You gave me #{column} -- I have no idea what to do with that."
    end    
    #puts product.to_json if product

  end

  def create
    super
    show()
  end

end