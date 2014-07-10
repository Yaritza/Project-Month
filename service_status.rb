require 'open-uri'
require 'nokogiri'
require 'pry'

class Service

	attr_accessor :doc, :lines, :status, :subway_hash, :description

	def initialize

		@lines = []
		@status = []
		@subway_hash = {}
		#@trainline = trainline
		@description = []
		@doc = Nokogiri::XML(open("http://web.mta.info/status/serviceStatus.txt"))
	end

	def lines
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
	 lines.zip(service_list)[0..9]
	end

	def service_hash
		output.each do |subway_status_pair|
			@subway_hash[subway_status_pair[0]] = subway_status_pair[1]
		end
		 @subway_hash 
	end
	def descriptive_status
		@doc.xpath("//text").collect do  |tag_contents|
			text =  tag_contents.text
			@description << text
		end
			@description
		
	end
end

service = Service.new
#testing:
#line_result = service.doc.xpath("//subway").xpath("//line").first


binding.pry