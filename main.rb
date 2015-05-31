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

require 'fox16'
require 'active_record'
require 'sqlite3'
require 'yaml'
require 'logger' 

include Fox

#ActiveRecord::Base.logger = Logger.new('database.log')
#configuration = YAML::load(IO.read("#{Dir.pwd}/config/database.yml"))
#ActiveRecord::Base.establish_connection(configuration['development'])

class EcocityAdmin < FXMainWindow

  def initialize(app)
    $APPLOG = Logger.new('app.log', 'monthly') 
    super(app, "Ecocity Admin", :width => 600, :height => 400)
    add_menu_bar

    self.connect(SEL_CLOSE, method(:on_close))
  end

  def on_close(sender, sel, event)
    $APPLOG.debug "Storing data .."
    puts "Storing data .."
    store_data
    exit
  end  

  def add_menu_bar
    # Add menu
  end
  
  def store_data
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
