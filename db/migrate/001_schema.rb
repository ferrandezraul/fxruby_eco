# For creatring new associations or new tables,
# edit this file and never touch db/schema.rb
# db/schema.rb is automatically updated when you run rake db:migrate

class Schema < ActiveRecord::Migration
  def change
    create_table :products, force: true do |t|
      t.string :name
      t.string :price_type   # por_unidad o por_kilo
      t.decimal :price, precision: 8, scale: 2  # without taxes
      t.decimal :taxes, precision: 8, scale: 2  # taxes
      t.decimal :tax_percentage, precision: 4, scale: 2  # % IVA
      t.decimal :total, precision: 8, scale: 2  # total
      t.decimal :weight, precision: 8, scale: 3
      t.boolean :outdated, default: false
      t.timestamps null: false
    end

    # Belongs to the composite pattern for products and subproducts
    create_table :children_containers, :id => false do |t|
      t.references :child
      t.references :container
    end

    add_index :children_containers, :child_id
    add_index :children_containers, [:container_id, :child_id], :unique => true

    create_table :customers, force: true do |t|
      t.string :name
      t.string :address
      t.string :nif
      t.string :customer_type
      t.timestamps null: false
    end

    create_table :orders, force: true do |t|
      t.date :date
      t.belongs_to :customer, index: true
      t.decimal :price, precision: 8, scale: 2 # without taxes
      t.decimal :taxes, precision: 8, scale: 2 # taxes
      t.decimal :total, precision: 8, scale: 2 # with taxes
      t.timestamps null: false
    end

    create_table :line_items do |t|
      t.belongs_to :order, index: true
      t.belongs_to :product, index: true
      t.integer :quantity
      t.decimal :weight, precision: 8, scale: 3
      t.decimal :price, precision: 8, scale: 2  # without taxes
      t.decimal :taxes, precision: 8, scale: 2  # taxes
      t.decimal :total, precision: 8, scale: 2  # with taxes
      t.timestamps null: false
    end

  end
end