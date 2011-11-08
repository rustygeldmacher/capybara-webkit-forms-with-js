require 'rspec'
require 'rspec/autorun'
require 'capybara/driver/webkit'
require 'capybara/driver/webkit/browser'

$webkit_browser = Capybara::Driver::Webkit::Browser.new(:socket_class => TCPSocket, :stdout => nil)

Capybara.register_driver :reusable_webkit do |app|
  Capybara::Driver::Webkit.new(app, :browser => $webkit_browser)
end
