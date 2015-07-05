include Fox

class ProductsTable < FXTable
  attr_reader :current_product

  COLUMN_ID = 0
  COLUMN_NAME = 1
  COLUMN_RAW_PRICE = 2
  COLUMN_TAX_PERCENTAGE = 3
  COLUMN_TAXES = 4
  COLUMN_TOTAL = 5
  NUM_COLUMNS = 6
  
  def initialize(parent)
    super(parent, :opts => TABLE_COL_SIZABLE|TABLE_ROW_SIZABLE|LAYOUT_FILL_X|LAYOUT_FILL_Y)

    fill_table(Product.all.where( :outdated => false ))

    self.connect(SEL_REPLACED, method(:on_cell_changed))
    self.connect(SEL_DOUBLECLICKED, method(:on_cell_double_clicled))
    self.connect(SEL_COMMAND, method(:on_new_selected))
  end

  def fill_table(products)
    setTableSize(0, NUM_COLUMNS)

    columnHeaderMode = LAYOUT_FILL_X
    rowHeaderMode = LAYOUT_FILL_X
    setColumnText(COLUMN_ID, "ID")
    setColumnText(COLUMN_NAME, "NAME")
    setColumnText(COLUMN_RAW_PRICE, "PRICE WITHOUT TAXES")
    setColumnText(COLUMN_TAX_PERCENTAGE, "IVA %")
    setColumnText(COLUMN_TAXES, "IVA EUR")
    setColumnText(COLUMN_TOTAL, "TOTAL")

    columnHeader.setItemJustify(COLUMN_ID, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_NAME, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_RAW_PRICE, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_TAX_PERCENTAGE, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_TAXES, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_TOTAL, FXHeaderItem::CENTER_X)

    products.each do |product|
      add_product(product)
    end
  end

  def add_product( product )
    num_rows = getNumRows
    appendRows( 1 )
    set_product_in_row( num_rows, product )
  end

  def set_product_in_row( row, product )
    setItemText( row, COLUMN_ID, product.id.to_s )
    setItemText( row, COLUMN_NAME, product.name )
    setItemText( row, COLUMN_RAW_PRICE, "#{ sprintf('%.2f', product.price ) }" )
    setItemText( row, COLUMN_TAX_PERCENTAGE, "#{ sprintf('%.2f', product.tax_percentage ) }" )
    setItemText( row, COLUMN_TAXES, "#{ sprintf('%.2f', product.taxes ) }" )
    setItemText( row, COLUMN_TOTAL, "#{ sprintf('%.2f', product.total ) }" )
  end

  def reset
    clearItems
    fill_table(Product.all.where( :outdated => false ))
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
      product = Product.find_by!( :name => getItemText( row, COLUMN_NAME ),
                                  :price => getItemText( row, COLUMN_RAW_PRICE ) )

      setItemText( row, COLUMN_ID, product.id.to_s )
    when COLUMN_NAME
      product_id = getItemText( row, COLUMN_ID ).to_i
      new_name = getItemText( row, COLUMN_NAME )

      Product.update( product_id, :name => new_name)      
    when COLUMN_RAW_PRICE
      product_id = getItemText( row, COLUMN_ID ).to_i
      new_price = getItemText( row, COLUMN_RAW_PRICE ).to_f
      setItemText( row, COLUMN_RAW_PRICE, sprintf('%.2f', new_price.round(2) ) )

      Product.update( product_id, :price => new_price.round(2) ) 
    when COLUMN_TAX_PERCENTAGE
      product_id = getItemText( row, COLUMN_ID ).to_i
      new_taxes = getItemText( row, COLUMN_TAX_PERCENTAGE )

      Product.update( product_id, :tax_percentage => new_taxes) 
    else
      puts "You gave me #{column} -- I have no idea what to do with that."
    end    

    #puts product.to_json if product

  end

  def on_cell_double_clicled( sender, sel, table_pos)
    # nothing
  end

  def on_new_selected( sender, sel, table_pos)
    row = table_pos.row
    @current_product = Product.find_by!( :id => getItemText( row, COLUMN_ID ) ) 
  end

  def create
    super
    show()
  end

end