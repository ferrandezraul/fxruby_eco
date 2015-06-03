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
      setItemText( index, 0, product.name )
      setItemText( index, 1, product.price.to_s )
    end

    self.connect(SEL_CHANGED, method(:on_cell_changed))
  end

  def create
    super
    show()
  end

  def on_cell_changed(table, cell, table_pos)
    puts "Here one #{table.to_s} which is #{table.class.name}"
    puts "Here two #{cell} which is #{cell.class.name}"
    puts "Here three #{table_pos.to_s} which is #{table_pos.class.name}"
  end

end