class Schema < ActiveRecord::Migration
  def change
    create_table :products, force: true do |t|
      t.string :name
      t.decimal :price, precision: 2, scale: 2
      t.decimal :weight, precision: 2, scale: 2
    end
  end
end