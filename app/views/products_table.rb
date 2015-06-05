include Fox

class ProductsTable < FXTable
  attr_reader :product
  
  def initialize(parent, products)
    super(parent, :opts => LAYOUT_FILL)

    @products = products

    $APPLOG.debug "Number of products: #{@products.count}"

    setTableSize(@products.count, 3)

    setColumnText(0, "ID")
    setColumnText(1, "Name")
    setColumnText(2, "Price")

    rowHeaderMode = ~LAYOUT_FIX_WIDTH
    columnHeader.setItemJustify(0, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(1, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(2, FXHeaderItem::CENTER_X)

    @products.each_with_index do | product, index |
      setItemText( index, 0, product.id.to_s )
      setItemText( index, 1, product.name )
      setItemText( index, 2, product.price.to_s )
    end

    self.connect(SEL_REPLACED, method(:on_cell_changed))
  end

  def create
    super
    show()
  end

  def on_cell_changed(sender, sel, table_pos)
    # table_pos fm = from
    #           to = to
    # Table has changed from cell between fm and to
    # Assume only a cell is changed
    column = table_pos.fm.col
    row = table_pos.fm.row

    puts "Update row #{row}"
    puts "Update column #{column}"

    product_id = getItemText( row, 0 ).to_i
    product = Product.find_by( :id => product_id )

    #puts product.to_json if product

    case column
    when 1
      new_name = getItemText( row, 1 )
      Product.update( product_id, :name => new_name)      
    when 2
      new_price = getItemText( row, 2 )
      Product.update( product_id, :price => new_price) 
    else
      puts "You gave me #{column} -- I have no idea what to do with that."
    end    

  end

end