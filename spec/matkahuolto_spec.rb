require 'spec_helper.rb'

describe Matkahuolto do
	context "using valid and precise street address" do  
		subject { described_class.new("04400", "Ainolankatu") }

		it "sets the postcode as expected" do
			subject.postcode.should == "04400"
		end

		it "sets the street address as expected" do
			subject.street_address.should == "Ainolankatu"
		end

		it "should build valid xml document" do
			doc = Nokogiri::XML::Document.parse(subject.xml_request)
			doc.at('Login').text.should == "1234567"
			doc.at('StreetAddress').text.should == subject.street_address
			doc.at('PostalCode').text.should == subject.postcode
		end

		it "gets the delivery points from Matkahuolto" do
			VCR.use_cassette('search_by_precise_address') do
				offices = subject.get_deliverypoints
				offices.should be_a_kind_of Array
				offices.first.should have_key("Name")
				subject.office_types.should include(offices.first["Type"])
			end
		end
	end

	context "using invalid address" do
		it "raises an error if postcode was given as street address" do
			expect {
				described_class.new("04400", "04400")
			}.to raise_error(
				Matkahuolto::InvalidAddress, /street address/
			)
		end

		it "raises an error with invalid postcode" do
			expect {
				described_class.new("asdfg", "Ainolankatu")
			}.to raise_error(
				Matkahuolto::InvalidAddress, /postcode/
			)
		end
	end
end