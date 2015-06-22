include Fox

class OrdersTable < FXTable

  COLUMN_ID = 0
  COLUMN_CUSTOMER = 1
  COLUMN_ITEMS = 2
  COLUMN_PRICE = 3
  NUM_COLUMNS = 4
  
  def initialize(parent, orders)
    super(parent, :opts => LAYOUT_FILL|TABLE_COL_SIZABLE)

    @orders = orders

    $APPLOG.debug "Number of orders: #{@orders.count}"

    fill_table( @orders )

    #self.connect(SEL_REPLACED, method(:on_cell_changed))
    #self.connect(SEL_DOUBLECLICKED, method(:on_cell_double_clicled))
  end

  def fill_table(orders)
    setTableSize(orders.count, NUM_COLUMNS)

    setColumnText(COLUMN_ID, "ID")
    setColumnText(COLUMN_CUSTOMER, "Customer")
    setColumnText(COLUMN_ITEMS, "Line Items")
    setColumnText(COLUMN_PRICE, "Price")

    rowHeaderMode = ~LAYOUT_FIX_WIDTH
    columnHeader.setItemJustify(COLUMN_ID, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_CUSTOMER, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_ITEMS, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_PRICE, FXHeaderItem::CENTER_X)

    orders.each do |order|
      add_order(order)
    end
  end

  def add_order(order)
    setItemText( index, COLUMN_ID, order.id.to_s )
    setItemText( index, COLUMN_CUSTOMER, order.customer.name )
    setItemText( index, COLUMN_ITEMS, order.line_items )
    setItemText( index, COLUMN_PRICE, order.price )
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