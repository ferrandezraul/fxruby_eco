require 'active_record'

class Product < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true
  validates :taxes, presence: true
end
