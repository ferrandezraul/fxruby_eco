include Fox

class OrdersTable < FXTable
  attr_reader :current_order

  COLUMN_ID = 0
  COLUMN_DATE = 1
  COLUMN_CUSTOMER = 2
  COLUMN_ITEMS = 3
  COLUMN_RAW_PRICE = 4
  COLUMN_TAXES = 5
  COLUMN_TOTAL = 6
  NUM_COLUMNS = 7
  
  def initialize(parent)
    super(parent, :opts => TABLE_COL_SIZABLE|TABLE_ROW_SIZABLE|LAYOUT_FILL_X|LAYOUT_FILL_Y)

    fill_table

    self.connect(SEL_COMMAND, method(:on_new_selected))
    #self.connect(SEL_REPLACED, method(:on_cell_changed))
    #self.connect(SEL_DOUBLECLICKED, method(:on_cell_double_clicled))
  end

  def fill_table
    setTableSize(0, NUM_COLUMNS)

    columnHeaderMode = LAYOUT_FILL
    rowHeaderMode = LAYOUT_FILL
    
    setColumnText(COLUMN_ID, "ID")
    setColumnText(COLUMN_DATE, "DATE")
    setColumnText(COLUMN_CUSTOMER, "Customer")
    setColumnText(COLUMN_ITEMS, "Line Items")
    setColumnText(COLUMN_RAW_PRICE, "Price without taxes")
    setColumnText(COLUMN_TAXES, "Taxes")
    setColumnText(COLUMN_TOTAL, "Total")

    setColumnWidth(COLUMN_ID, 50)
    setColumnWidth(COLUMN_DATE, 200)
    setColumnWidth(COLUMN_CUSTOMER, 200)
    setColumnWidth(COLUMN_ITEMS, 200)
    setColumnWidth(COLUMN_RAW_PRICE, 200)
    setColumnWidth(COLUMN_TAXES, 200)
    setColumnWidth(COLUMN_TOTAL, 200)

    columnHeader.setItemJustify(COLUMN_ID, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_DATE, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_CUSTOMER, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_ITEMS, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_RAW_PRICE, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_TAXES, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_TOTAL, FXHeaderItem::CENTER_X)

    Order.all.each do |order|
      add_order(order)
    end
  end 

  def add_order(order)
    num_rows = getNumRows
    appendRows( 1 )

    line_items_text = TokenizerHelper.line_items_string( order )

    setItemText( num_rows, COLUMN_ID, order.id.to_s )
    setItemText( num_rows, COLUMN_DATE, order.date.strftime("%d/%m/%Y") )
    setItemText( num_rows, COLUMN_CUSTOMER, order.customer.name )
    setItemText( num_rows, COLUMN_ITEMS, line_items_text )
    setItemText( num_rows, COLUMN_RAW_PRICE, "#{sprintf('%.2f', order.price )} EUR" )
    setItemText( num_rows, COLUMN_TAXES, "#{sprintf('%.2f', order.taxes )} EUR" )
    setItemText( num_rows, COLUMN_TOTAL, "#{sprintf('%.2f', order.total )} EUR" )

    # Set row height based on the number of lines in line items
    setRowHeight( num_rows, line_items_text.scan(/\n/).length * 30 ) 
  end

  def reset
    clearItems
    @current_order = nil
    fill_table
  end

  def on_new_selected( sender, sel, table_pos)
    row = table_pos.row
    @current_order = Order.find_by!( :id => getItemText( row, COLUMN_ID ) ) 
  end

  def create
    super
    show()
  end

end