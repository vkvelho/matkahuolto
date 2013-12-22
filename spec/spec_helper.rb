require 'rubygems'
require 'bundler'

Bundler.require(:default, :test)

require File.join(File.dirname(__FILE__), '..', 'matkahuolto.rb')
# Dir["./spec/support/**/*.rb"].each {|f| require f}

VCR.configure do |c|
	c.allow_http_connections_when_no_cassette = true
	c.cassette_library_dir = 'spec/vcr_cassettes'
	c.hook_into :webmock
end
