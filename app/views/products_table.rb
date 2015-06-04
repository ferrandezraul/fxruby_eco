include Fox

class ProductsTable < FXTable
  attr_reader :product
  
  def initialize(parent, products)
    super(parent, :opts => LAYOUT_FILL)

    @products = products

    $APPLOG.debug "Number of products: #{@products.count}"

    setTableSize(@products.count, 2)

    setColumnText(0, "Name")
    setColumnText(1, "Price")

    rowHeaderMode = ~LAYOUT_FIX_WIDTH
    columnHeader.setItemJustify(0, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(1, FXHeaderItem::CENTER_X)

    @products.each_with_index do | product, index |
      #setItemData( index 0, product )
      setItemText( index, 0, product.name )
      setItemText( index, 1, product.price.to_s )
    end

    self.connect(SEL_REPLACED, method(:on_cell_changed))
  end

  def create
    super
    show()
  end

  def on_cell_changed(sender, sel, table_pos)
    column = table_pos.fm.col
    row = table_pos.fm.row

    puts "Update row #{row}"
    puts "Update column #{column}"

    p_name = getItemText( row, 0 )
    p_price = getItemText( row, 1 )

    puts "Update product with name #{p_name} and price #{p_price}"

    # New Data to set
    puts sel.to_s
    puts sel.to_json
    puts sel.to_i

    product = Product.find_by( :name => p_name, :price => p_price )

    puts "Not found" if product == nil

    puts product.to_json if product

  end

end