require 'csv'

class ProductsBuilder

	def self.create_from_csv( file )
		raise Exception.new("#{file} does npot exist!!") if !File.exist?(file)
		
		Product.destroy_all

		# TODO (handle errors in csv)
	    CSV.foreach(file, :headers => true) do |csv_row|
	      #puts "Row is #{csv_row}" #puts "Row is #{csv_row.class}" #puts "Row inspect is #{csv_row.inspect}"
	      #puts "Row inspect is #{csv_row.to_hash}"
	      Product.create!( csv_row.to_hash )
	    end
	end

	def self.build_from_csv( file )
		raise Exception.new("#{file} does npot exist!!") if !File.exist?(file)
		
		products = Array.new
		
	    CSV.foreach(file, :headers => true) do |csv_row|
	      products << Product.new( csv_row.to_hash )
	    end

	    products
	end

end
