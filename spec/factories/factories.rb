require 'product'
require 'customer'

FactoryGirl.define do

  factory :product, class: Product do
    sequence(:name ) { |n| "Product #{n}" }
    price_type  Product::PriceType::POR_UNIDAD
    price SecureRandom.random_number(20)
    tax_percentage 4
  end

  factory :soca, class: Product do
    name "Soca"
    price_type  Product::PriceType::POR_UNIDAD
    price 2.5
    tax_percentage 4
  end

  factory :pigat, class: Product do
    name "Pigat"
    price_type  Product::PriceType::POR_UNIDAD
    price 5
    tax_percentage 4
  end

  # children added in specs
  factory :lote, class: Product do
    name "Lote de 5 Kilos"
    price_type  Product::PriceType::POR_UNIDAD
    price 40
    tax_percentage 10
  end

  # children added in specs
  factory :lote_de_pan, class: Product do
    name "Lote de pan"
    price_type  Product::PriceType::POR_UNIDAD
    price 20
    tax_percentage 10
    after(:create) {|lote_de_pan| lote_de_pan.children = [create(:product),create(:product)]}
  end

  factory :customer, class: Customer do
    name "Raul"
    address  "Oxford Street"
    nif  "564329876-X"
    customer_type Customer::Type::CLIENTE
  end
end