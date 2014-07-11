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
			@doc.xpath("//name").collect do |lines|
				lines = lines.text
				@lines = lines
			end
	end


	def descriptive_status
		@doc.xpath('//subway//line').each do |line|
			puts "******************************"
			train_name = line.at_css("/name").text
			puts train_name
			train_status = line.at_css("status").text
			puts train_status
			descriptive_status = line.xpath("text")
			
			html = Nokogiri::HTML(descriptive_status.text)
			
			html.css(".plannedWorkDetailLink").each do |detail|
				puts train_name
				puts "----------------"
				puts detail.children.text.inspect
			end

			html.css(".plannedWorkDetail").each do |detail|
				puts train_name
				puts "----------------"
				puts "THIS IS THE DETAIL:"
				puts detail.children.text.inspect
			end

			if train_status == "GOOD SERVICE"
				puts "Hooray! Good train service today!"
			else 
				puts "Give yourself extra time. There are issues with your line."
				puts "here is the description: "
				status_text = descriptive_status.text
				cleaned_status = status_text.scan(/<br\/><br\/>(.+)<br\/><br\/>/m) # slightly working 
				
				new_clean_status = cleaned_status.flatten

				new_clean_status.each do |line_info|
					puts line_info.gsub(/<(\/)*(\w)+(\s)*(\/)*>/m, "")
				end 
			end 
		end 
		@description
	end
end

 service = Service.new
 service.descriptive_status
 #testing:
 #line_result = service.doc.xpath("//subway").xpath("//line").first