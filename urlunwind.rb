require 'rubygems'
require 'vendor/sinatra/lib/sinatra.rb'
require 'net/http'


get '/' do
  haml :index
end

post '/unwind' do
  @unwound_url, @unwind_error = unwind(params[:url])
  haml :index
end

get '/unwind/:url' do
  @unwound_url, @unwind_error = unwind(params[:url])
  haml :index
end

get '/stylesheets/style.css' do
  sass :style
end

helpers do
  def unwind(url)
    url.strip! unless url.nil?
    if url.nil? or url.empty?
      error = 'Please enter a url.'
    else
      @url = url
      begin
        uri = URI.parse(url)
        response = Net::HTTP.start(uri.host, uri.port) { |http| http.head(uri.path) }
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
    [to_url, error]
  end
end
