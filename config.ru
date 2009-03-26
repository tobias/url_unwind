#-*-ruby-*-
#ENV['GEM_PATH'] = '/home/urlunwind/rubygems'
require 'rubygems'
#require 'json'

#hack to work with new rack (0.9.1)
require 'rack/file'
class Rack::File
   MIME_TYPES = Hash.new { |hash, key| Rack::Mime::MIME_TYPES[".#{key}"] }
end

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
