require 'open-uri'
require 'nokogiri'
require 'pry'

class Service

	attr_accessor :doc, :lines, :status, :subway_hash, :description

	def initialize

		@lines = []
		@status = []
		@description = []
		@subway_hash = {}
		#@trainline = trainline
		@doc = Nokogiri::XML(open("http://web.mta.info/status/serviceStatus.txt"))
	end

	def subway_list
		#Hard coding  for a test-line.
		#@trainline = NQR
		#Subway details are in parent <subway> tag
		#
		#<line> <name> contains line names
		#subway options are 123, 456, 7, ACE, BDFM, G, JZ, L, NQR, S
		
		#Following line isolates the subway specific data (first 10 are all subways only)
			@doc.xpath("//name").collect do |lines|
				lines = lines.text
				@lines = lines
			end
	end

	def service_list
		@doc.xpath("//status").collect do |status|
			 status = status.text
			 @status = status
		end
	end

	def output
	 subway_list.zip(service_list)[0..9]

	end

	def service_hash
		output.each do |subway_status_pair|
			@subway_hash[subway_status_pair[0]] = subway_status_pair[1]
		end
		 @subway_hash 
	end

	def print_out
		puts @doc
	end

	def descriptive_status
		@doc.xpath("//line").collect do |line|
			puts "******************************"
			train_name = line.at_css("/name").text
			puts train_name
			train_status = line.at_css("status").text
			puts train_status
			# binding.pry if train_name == "G"
			# descriptive_status = line.children[5].children[0] # .text
			# puts "here is line before the child elements: ",line
			descriptive_status = line.children[5]
			
			# if descriptive_status != nil 
			# 	final_description = descriptive_status.to_s
			# 	puts "HERE "
			# 	puts final_description.scan(/\<\p\>/)
			# end

			if train_status == "GOOD SERVICE"
				puts "Hooray! Good train service today!"
			else 
				puts "Give yourself extra time. There are issues with your line."
				puts "here is the description: "
				status_text = descriptive_status.text
				cleaned_status = status_text.scan(/<br\/><br\/>(.+)<br\/><br\/>/m) # slightly working 
				if cleaned_status
					
				end 
				# puts final_description.inspect
				# final_status = final_description.split(/[&lt;P&gt;].../)
				# puts final_status
			end 
		end 
		@description
	end
end

 service = Service.new
 service.descriptive_status
 binding.pry
 #testing:
 #line_result = service.doc.xpath("//subway").xpath("//line").first