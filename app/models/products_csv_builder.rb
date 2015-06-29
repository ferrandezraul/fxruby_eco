require 'csv'

class ProductsCSVBuilder

	# Creates products in database from a csv file
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

	# Returns an array of products from a csv file without modifying database
	def self.build_from_csv( file )
		raise Exception.new("#{file} does npot exist!!") if !File.exist?(file)
		
		products = Array.new
		
	    CSV.foreach(file, :headers => true) do |csv_row|
	      products << Product.new( csv_row.to_hash )
	    end

	    products
	end

	# Creates a csv file with product attributes from database
	def self.export_csv( file )
		CSV.open(file, "wb") do |csv|

		# Add headers
        csv << Product.attribute_names

        # Add product attributes
        Product.all.each do |product|
          csv << product.attributes.values
        end
      end
	end

end
