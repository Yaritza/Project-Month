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
		#only pairs train lines with status. 
		#Will be incorporating  descriptive_stautus later.
		output.each do |subway_status_pair|
			@subway_hash[subway_status_pair[0]] = subway_status_pair[1]
		end
		 @subway_hash 
	end
	def descriptive_status

		################
		# @doc.xpath("//line").map do  |line|
		# 	train_name =  line.at_css("name").text
		# 	train_status = line.at_css("status").text
		# 	descriptive_status = nil
		# 	binding.pry
		# 	#descriptive_status = line.at_css("TitleDelay") #||= line.at_css("TitlePlannedWork plannedWorkDetailLink") ||= line.at_css("TitleServiceChange")
		# 	@description << [train_name, train_status] 
		# end
		# 	@description[0..9]
		
		# def descriptive_status
		# binding.pry
		#####################

		@doc.xpath("//line").collect do |line|
			puts "******************************"
			train_name = line.at_css("/name").text
			train_status = line.at_css("status").text
			# binding.pry if train_name == "G"
			descriptive_status = line.children[5].children[0]
			if train_status == "GOOD SERVICE"
				puts "Hooray! Good service  for the #{train_name} today!"
			else 
				puts "Give yourself extra time. There are issues with your line."
				puts "Here is the description: "
					 description = descriptive_status.to_s
					 @description = description
					 #Our description live between this gibberish &lt;br/&gt;&lt;br/&gt;
			end 
		end 
		@description = @description.gsub("&lt;br/&gt;&lt;br/&gt;", "XXX")
		@description = @description.gsub(/(XXX).+(XXX)/)
	end
end


html = <<-HTML

&lt;span class="TitleServiceChange" &gt;Sandy Reroute&lt;/span&gt;
                    &lt;span class="DateStyle"&gt;
                    &amp;nbsp;Posted:&amp;nbsp;07/10/2014&amp;nbsp; 8:01PM
                    &lt;/span&gt;&lt;br/&gt;&lt;br/&gt;
                  &lt;STRONG&gt;[FF]&lt;BR&gt;[R] No trains between Whitehall St and Downtown Brooklyn - Take the [N] instead&lt;BR&gt;Transfer between [N] and [R] trains at Canal St and Atlantic Av-Barclays Ctr&lt;BR&gt;&lt;/STRONG&gt;Weekdays until Oct 2014
                &lt;br/&gt;&lt;br/&gt;

HTML

require 'pp'

pp Nokogiri::HTML(html).text

# service = Service.new
#testing:
#line_result = service.doc.xpath("//subway").xpath("//line").first


# binding.pry