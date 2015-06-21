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
require 'active_record'
require 'sqlite3'
require 'yaml'
require 'logger'
require 'csv'

require 'product' 
require 'customer'
require 'products_view'
require 'customers_view'

include Fox

class EcocityAdmin < FXMainWindow

  def initialize(app)
    super(app, "Ecocity Admin", :width => 600, :height => 400)

    $APPLOG = Logger.new('app.log', 'monthly') 

    setup_database_conection

    add_menu_bar

    load_sample_data

    tabbook = FXTabBook.new(self, :opts => LAYOUT_FILL)

    FXTabItem.new(tabbook, "Products") 
    @products_view = ProductsView.new( tabbook, Product.all )

    FXTabItem.new(tabbook, "Customers") 
    CustomersView.new( tabbook, Customer.all )

    FXTabItem.new(tabbook, "Invoices") 
    FXVerticalFrame.new(tabbook, :opts => FRAME_RAISED|LAYOUT_FILL)

    self.connect(SEL_CLOSE, method(:on_close))
  end

  def on_close(sender, sel, event)
    $APPLOG.debug "Closing .."
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

    import_products_command = FXMenuCommand.new(import_menu_pane, "Import Products as CSV")
    import_products_command.connect(SEL_COMMAND) do
      import_products_as_csv
    end

    import_customers_command = FXMenuCommand.new(import_menu_pane, "Import Customers as CSV")
    import_customers_command.connect(SEL_COMMAND) do
      import_customers_as_csv
    end

    FXMenuTitle.new(menu_bar, "Export", :popupMenu => export_menu_pane)
    FXMenuTitle.new(menu_bar, "Import", :popupMenu => import_menu_pane)
  end

  def export_products_as_csv
    CSV.open("db/products.csv", "wb") do |csv|
      csv << Product.attribute_names
      Product.all.each do |product|
        csv << product.attributes.values
      end
    end
  end

  def export_customers_as_csv
    CSV.open("db/customers.csv", "wb") do |csv|
      csv << Customer.attribute_names
      Customer.all.each do |customer|
        csv << customer.attributes.values
      end
    end
  end

  def import_products_as_csv
    answer = FXMessageBox.question( self, MBOX_YES_NO,
      "Watch out!", "This will delete all existing products and load your db/products.csv file. Do you accept it?" )

    if !File.exist?('db/products.csv')
      FXMessageBox.warning( self, MBOX_OK, "No file found", "No file db/products.csv found!")
      return
    end

    if answer == MBOX_CLICKED_YES
      Product.destroy_all

      # TODO (handle errors in csv)
      CSV.foreach("db/products.csv", :headers => true) do |csv_row|
        #puts "Row is #{csv_row}"
        #puts "Row is #{csv_row.class}"
        #puts "Row inspect is #{csv_row.inspect}"
        #puts "Row inspect is #{csv_row.to_hash}"
        Product.create!( csv_row.to_hash )
      end

      # Update UI !!
      @products_view.reset( Product.all)
    end
  end

  def import_customers_as_csv
    # TODO
  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end
end

if __FILE__ == $0  
  FXApp.new do |app|
    EcocityAdmin.new(app)
    app.create
    app.run
  end
end
