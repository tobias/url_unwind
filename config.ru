#-*-ruby-*-
require 'rubygems'
require 'vendor/sinatra/lib/sinatra.rb'

Sinatra::Application.default_options.merge!(
  :run => false,
  :env => :production
)

require 'urlunwind.rb'
run Sinatra.application
