class LineItemsTable < FXTable

  COLUMN_QUANTITY = 0
  COLUMN_WEIGHT = 1
  COLUMN_NAME = 2
  COLUMN_RAW_PRICE = 3
  COLUMN_TAX_PERCENTAGE = 4
  COLUMN_TAXES = 5
  COLUMN_TOTAL = 6
  NUM_COLUMNS = 7
  
  def initialize(parent, line_items)
    super(parent, :opts => TABLE_COL_SIZABLE|TABLE_ROW_SIZABLE|LAYOUT_FILL)

    fill_table(line_items)

    #self.connect(SEL_REPLACED, method(:on_cell_changed))
    #self.connect(SEL_DOUBLECLICKED, method(:on_cell_double_clicled))
  end

  def fill_table(line_items)
    setTableSize(0, NUM_COLUMNS)

    setColumnText(COLUMN_QUANTITY, "Quantity")
    setColumnText(COLUMN_WEIGHT, "Weight")
    setColumnText(COLUMN_NAME, "Item")
    setColumnText(COLUMN_RAW_PRICE, "Price")
    setColumnText(COLUMN_TAX_PERCENTAGE, "IVA %")
    setColumnText(COLUMN_TAXES, "IVA EUR" )
    setColumnText(COLUMN_TOTAL, "Total" )

    rowHeaderMode = LAYOUT_FILL_X

    setColumnWidth(COLUMN_QUANTITY, 50)
    setColumnWidth(COLUMN_WEIGHT, 100)
    setColumnWidth(COLUMN_NAME, 200)
    setColumnWidth(COLUMN_RAW_PRICE, 200)
    setColumnWidth(COLUMN_TAX_PERCENTAGE, 200)
    setColumnWidth(COLUMN_TAXES, 200)
    setColumnWidth(COLUMN_TOTAL, 200)

    columnHeader.setItemJustify(COLUMN_QUANTITY, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_WEIGHT, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_NAME, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_RAW_PRICE, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_TAX_PERCENTAGE, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_TAXES, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_TOTAL, FXHeaderItem::CENTER_X)

    line_items.each do |line_item|
      add_line_item(line_item)
    end
  end

  def add_line_item( line_item )
    num_rows = getNumRows
    appendRows( 1 )
    setItemText( num_rows, COLUMN_QUANTITY, line_item.quantity.to_s )
    setItemText( num_rows, COLUMN_WEIGHT, line_item.weight.to_s )
    setItemText( num_rows, COLUMN_NAME, line_item.product.name )
    setItemText( num_rows, COLUMN_RAW_PRICE, "#{sprintf('%.2f', line_item.price )} EUR" )
    setItemText( num_rows, COLUMN_TAX_PERCENTAGE, "#{sprintf('%.2f', line_item.product.tax_percentage )} %" )
    setItemText( num_rows, COLUMN_TAXES, "#{sprintf('%.2f', line_item.taxes )} EUR" )
    setItemText( num_rows, COLUMN_TOTAL, "#{sprintf('%.2f', line_item.total )} EUR" )
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