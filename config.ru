require "rubygems"
require "sinatra"
require "app"
require "hoptoad_notifier"

HoptoadNotifier.configure do |config|
  config.api_key = "c1e61cbd4c331d9dd66311c4e97e20f6"
end

use HoptoadNotifier::Rack

run Sinatra::Application
