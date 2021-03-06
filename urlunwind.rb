#ENV['GEM_PATH'] = '/home/urlunwind/rubygems'
require 'rubygems'
require 'vendor/sinatra/lib/sinatra.rb'
require 'net/http'
#require 'json'

get '/' do
  haml :index
end

get  '/unwind' do
  @url, @unwound_url, @unwind_error = unwind(params[:url])
  haml :index
end

post '/unwind' do
  @url, @unwound_url, @unwind_error = unwind(params[:url])
  haml :index
end

get '/unwind.json' do
  content_type 'application/json'

  @url, @unwound_url, @unwind_error = unwind(params[:url])
  # this is non-spec json
  # it would be much better to use the json gem for this, but it is
  # not available on dreamhost, and passenger dies intermittently
  # failing to load it when json is installed locally
  "{ \"from_url\": #{quoted_string(@url)}, \"to_url\": #{quoted_string(@unwound_url)}, \"error\": #{quoted_string(@unwind_error)}}"
end

get '/stylesheets/style.css' do
  content_type 'text/css'

  sass :style
end

helpers do
  def unwind(from_url)
    from_url.strip! unless from_url.nil?
    if from_url.nil? or from_url.empty?
      error = 'Please enter a url.'
    else
      from_url = "http://#{from_url}" unless from_url =~ %r{^http://}
      url = from_url
      begin
        uri = URI.parse(from_url)
        response = Net::HTTP.start(uri.host, uri.port) { |http| http.head(uri.path.empty? ? '/' : uri.path) }

        if response['location']
          to_url = response['location']
        elsif response.is_a?(Net::HTTPSuccess)
          #do nothing
        else
          error = 'An error occured accessing that url.'
        end
      rescue Exception => ex
        error = 'An error occured accessing that url.'
      end
    end
    [url, to_url, error]
  end
  
  CHAR_MAP = {
    '"' => '\"',
    '\\' => '\\\\',
    '/' => '\/'
  } unless defined?(CHAR_MAP)
    
  def quoted_string(str)
    str ? "\"#{str.gsub(/["\\\/]/) { CHAR_MAP[$&] }}\"" : 'null'
  end
  
end
