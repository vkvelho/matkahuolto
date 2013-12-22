require "matkahuolto/version"
require 'open-uri'

class Matkahuolto
	include HTTParty
	base_uri 'http://map.matkahuolto.fi/map24mh'
	format :xml
	headers 'accept' => 'text/xml'
	headers 'Content-Type' => 'text/xml'

	attr_accessor :street_address, :postcode, :delivery_points
	attr_reader :office_types

	def initialize(postcode, street_address = nil)
		@postcode = postcode.to_s
		@street_address = street_address.to_s
		@delivery_points = []

		@office_types = [
			"TRS", # Siwa
			"TRE", # Euromarket
			"TRV", # Valintatalo
			"MHA", # Matkahuolto
			"MHM", # Matkahuolto
			"MHN", # Matkahuolto
		]

		validate!
	end

	def get_deliverypoints
		status, xml_response = post(xml_request)
		# xml_doc = Nokogiri::XML(xml)

		hash_response = Crack::XML.parse xml_response
		offices = hash_response["MHSearchOfficesReply"]["Office"]
		return offices
	end

  	def xml_request
  		builder = Nokogiri::XML::Builder.new do |xml|
  		xml.MHSearchOfficesRequest {
			xml.Login "1234567"
			xml.Version "1.0"
			xml.StreetAddress street_address
			xml.PostalCode postcode
  		}
  		end
  		builder.to_xml
  	end

  	def post(xml_body)
		res = self.class.post('/searchoffices', :body => xml_body)
		[res.code, CGI::unescape(res.body)]
  	end

	private
  	def validate!
	  	raise InvalidAddress, "Invalid postcode" unless /(\d{5})/.match(postcode)
	  	unless street_address.empty?
	  		if /(\d{5})/.match(street_address)
	  			raise InvalidAddress, "Postcode given as street address"
	  		end

	  		if street_address.length < 3
	  			raise InvalidAddress, "Street address should be longer than 3 characters"
	  		end
	  	end
  	end

	class InvalidAddress < StandardError; end
end