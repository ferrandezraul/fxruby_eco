#---
# Excerpted from "FXRuby: Create Lean and Mean GUIs with Ruby",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/fxruby for more book information.
#---

# add current dir to LOAD_PATH 
$LOAD_PATH.unshift '.'
$LOAD_PATH.unshift './app/models/'
$LOAD_PATH.unshift './app/views/'

require 'fox16'
require 'sqlite3'
require 'yaml'
require 'logger'
require 'csv'

require 'product' 
require 'products_csv_builder'
require 'customers_csv_builder'
require 'customer'
require 'order'
require 'products_view'
require 'customers_view'
require 'orders_view'

include Fox
    
class EcocityAdmin < FXMainWindow

  def initialize(app)
    super(app, "Ecocity Admin", :width => 600, :height => 400)

    $APPLOG = Logger.new('app.log', 'monthly') 

    setup_database_conection

    add_menu_bar

    tabbook = FXTabBook.new(self, :opts => LAYOUT_FILL)

    FXTabItem.new(tabbook, "Products") 
    @products_view = ProductsView.new( tabbook, Product.all )

    FXTabItem.new(tabbook, "Customers") 
    @customers_view = CustomersView.new( tabbook, Customer.all )

    FXTabItem.new(tabbook, "Orders") 
    @orders_view = OrdersView.new( tabbook, Order.all )

    self.connect(SEL_CLOSE, method(:on_close))
  end

  def on_close(sender, sel, event)
    puts "Closing .."
    exit
  end

  def setup_database_conection
    ActiveRecord::Base.logger = Logger.new('database.log')
    configuration = YAML::load(IO.read("#{Dir.pwd}/db/config.yml"))
    ActiveRecord::Base.establish_connection(configuration['development'])
  end  

  def add_menu_bar
    menu_bar = FXMenuBar.new(self, :opts => LAYOUT_SIDE_TOP|LAYOUT_FILL_X)
    export_menu_pane = FXMenuPane.new(self)
    import_menu_pane = FXMenuPane.new(self)

    export_products_command = FXMenuCommand.new(export_menu_pane, "Export Products as CSV")
    export_products_command.connect(SEL_COMMAND) do
      export_products_as_csv
    end

    export_customers_command = FXMenuCommand.new(export_menu_pane, "Export Customers as CSV")
    export_customers_command.connect(SEL_COMMAND) do
      export_customers_as_csv
    end

    import_test_data = FXMenuCommand.new(import_menu_pane, "Import test data")
    import_test_data.connect(SEL_COMMAND) do
      ProductsCSVBuilder::create_from_csv("db/products.csv")
      CustomerCSVBuilder::create_from_csv("db/customers.csv")
    end

    import_products_command = FXMenuCommand.new(import_menu_pane, "Import Products as CSV")
    import_products_command.connect(SEL_COMMAND) do
      import_products_as_csv
    end

    import_customers_command = FXMenuCommand.new(import_menu_pane, "Import Customers as CSV")
    import_customers_command.connect(SEL_COMMAND) do
      import_customers_as_csv
    end

    FXMenuTitle.new(menu_bar, "Import", :popupMenu => import_menu_pane)
    FXMenuTitle.new(menu_bar, "Export", :popupMenu => export_menu_pane)
  end

  def export_products_as_csv
    dialog = FXFileDialog.new(self, "Export CSV File with products") 
    dialog.patternList = [ "CSV Files (*.csv)" ]
    if dialog.execute != 0
      ProductsCSVBuilder::export_csv(dialog.filename)
      FXMessageBox.warning( self, MBOX_OK, "Products Exported", 
        "Products exported in #{dialog.filename}")
    end
  end

  def export_customers_as_csv
    dialog = FXFileDialog.new(self, "Export CSV File with products") 
    dialog.patternList = [ "CSV Files (*.csv)" ]
    if dialog.execute != 0
      CustomerCSVBuilder::export_csv(dialog.filename)
      FXMessageBox.warning( self, MBOX_OK, "Customers Exported", 
        "Customers exported in #{dialog.filename}")
    end
  end

  def import_products_as_csv
    answer = FXMessageBox.question( self, MBOX_YES_NO,
      "Watch out!", "This will delete all existing products. Go ahead?" )

    if answer == MBOX_CLICKED_YES
      dialog = FXFileDialog.new(self, "Open CSV File with products") 
      dialog.patternList = [ "CSV Files (*.csv)" ]
      if dialog.execute != 0
        ProductsCSVBuilder::create_from_csv(dialog.filename)
        # Update UI !!
        @products_view.reset(Product.all)
        FXMessageBox.warning( self, MBOX_OK, "#{Product.count} Products Imported", 
          "#{Product.count} Products Imported")
        end
      end
  end

  def import_customers_as_csv
    answer = FXMessageBox.question( self, MBOX_YES_NO,
      "Watch out!", "This will delete all existing customers. Go ahead?" )

    if answer == MBOX_CLICKED_YES
      dialog = FXFileDialog.new(self, "Open CSV File with customers") 
      dialog.patternList = [ "CSV Files (*.csv)" ]
      if dialog.execute != 0
        CustomerCSVBuilder::create_from_csv(file)

        # Update UI !!
        @customers_view.reset(Customer.all)
        FXMessageBox.warning( self, MBOX_OK, "#{Customer.count} Customer Imported", 
            "#{Customer.count} Customer Imported")
      end
    end
  end

  def create
    super
    show(PLACEMENT_MAXIMIZED)
  end
end

if __FILE__ == $0  
  FXApp.new do |app|
    EcocityAdmin.new(app)
    app.create
    app.run
  end
end
