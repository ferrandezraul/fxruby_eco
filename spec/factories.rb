require 'product'
require 'customer'

FactoryGirl.define do

  factory :product, class: Product do
    name "Soca"
    price_type  Product::PriceType::POR_UNIDAD
    price 2.5
    tax_percentage 4
  end

  # children added in specs
  factory :lote, class: Product do
    name "Lote de 5 Kilos"
    price_type  Product::PriceType::POR_UNIDAD
    price 40
    tax_percentage 10
  end

  factory :customer, class: Customer do
    name "Raul"
    address  "Oxford Street"
    nif  "564329876-X"
    customer_type Customer::Type::CLIENTE
  end
end