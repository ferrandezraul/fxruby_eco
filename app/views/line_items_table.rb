class LineItemsTable < FXTable

  COLUMN_ID = 0
  COLUMN_QUANTITY = 1
  COLUMN_NAME = 2
  COLUMN_PRICE = 3
  NUM_COLUMNS = 4
  
  def initialize(parent, line_items)
    super(parent, :opts => LAYOUT_FILL|TABLE_COL_SIZABLE)

    @line_items = line_items

    fill_table(@line_items)

    #self.connect(SEL_REPLACED, method(:on_cell_changed))
    #self.connect(SEL_DOUBLECLICKED, method(:on_cell_double_clicled))
  end

  def fill_table(line_items)
    setTableSize(0, NUM_COLUMNS)

    setColumnText(COLUMN_ID, "ID")
    setColumnText(COLUMN_QUANTITY, "Quantity")
    setColumnText(COLUMN_NAME, "Item")
    setColumnText(COLUMN_PRICE, "Price")

    rowHeaderMode = LAYOUT_FILL_X

    columnHeader.setItemJustify(COLUMN_ID, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_QUANTITY, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_NAME, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_PRICE, FXHeaderItem::CENTER_X)

    line_items.each do |line_item|
      add_line_item(line_item)
    end
  end

  def add_line_item( line_items )
    num_rows = getNumRows
    appendRows( 1 )
    setItemText( num_rows, COLUMN_ID, line_item.id.to_s )
    setItemText( num_rows, COLUMN_QUANTITY, line_item.quantity.to_s )
    setItemText( num_rows, COLUMN_NAME, line_item.product.name )
    setItemText( num_rows, COLUMN_PRICE, sprintf('%.2f', line_item.product.price ) )
  end

  def reset( line_items )
    clearItems
    fill_table(line_items)
  end

  def on_cell_changed(sender, sel, table_pos)
    # TODO
  end

  def on_cell_double_clicled( sender, sel, table_pos)
    # TODO
  end

  def create
    super
    show()
  end

end