#-*-ruby-*-
#ENV['GEM_PATH'] = '/home/urlunwind/rubygems'
require 'rubygems'
#require 'json'
require 'vendor/sinatra/lib/sinatra.rb'


disable :run
set :env, :production
set :raise_errors, true
set :views, File.dirname(__FILE__) + '/views'
set :public, File.dirname(__FILE__) + '/public'
set :app_file, __FILE__

log = File.new("log/sinatra.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)


require 'urlunwind.rb'
run Sinatra.application
