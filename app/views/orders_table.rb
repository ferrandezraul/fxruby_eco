include Fox

class OrdersTable < FXTable

  COLUMN_ID = 0
  COLUMN_DATE = 1
  COLUMN_CUSTOMER = 2
  COLUMN_ITEMS = 3
  COLUMN_PRICE = 4
  NUM_COLUMNS = 5
  
  def initialize(parent, orders)
    super(parent, :opts => LAYOUT_FILL|TABLE_COL_SIZABLE)

    @orders = orders

    $APPLOG.debug "Number of orders: #{@orders.count}"

    fill_table( @orders )

    #self.connect(SEL_REPLACED, method(:on_cell_changed))
    #self.connect(SEL_DOUBLECLICKED, method(:on_cell_double_clicled))
  end

  def fill_table(orders)
    setTableSize(0, NUM_COLUMNS)

    columnHeaderMode = LAYOUT_FILL_X
    rowHeaderMode = LAYOUT_FILL_X
    
    setColumnText(COLUMN_ID, "ID")
    setColumnText(COLUMN_DATE, "DATE")
    setColumnText(COLUMN_CUSTOMER, "Customer")
    setColumnText(COLUMN_ITEMS, "Line Items")
    setColumnText(COLUMN_PRICE, "Price")

    columnHeader.setItemJustify(COLUMN_ID, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_DATE, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_CUSTOMER, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_ITEMS, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_PRICE, FXHeaderItem::CENTER_X)

    orders.each do |order|
      add_order(order)
    end
  end

  def add_order(order)
    num_rows = getNumRows
    appendRows( 1 )

    setItemText( num_rows, COLUMN_ID, order.id.to_s )
    setItemText( num_rows, COLUMN_DATE, order.date.strftime("%d/%m/%Y") )
    setItemText( num_rows, COLUMN_CUSTOMER, order.customer.name )
    setItemText( num_rows, COLUMN_ITEMS, order.items_to_s )
    #setItemText( num_rows, COLUMN_PRICE, order.price )
  end

  def reset(orders)
    clearItems
    fill_table(orders)
  end

  def create
    super
    show()
  end

end