require 'rubygems'
require 'vendor/sinatra/lib/sinatra.rb'



get '/' do
  haml :index
end

post '/unwind' do
  unwind(params[:url])
  haml :index
end

get '/unwind/:url' do
  unwind(params[:url])
  haml :index
end

def unwind(url)
  if url.nil? or url.empty?
    @unwind_error = 'Please enter a url.'
  else
    begin
      response = Net::HTTP.get_response(URI.parse(url))

      if response['location']
        @unwound_url = response['location']
      elsif response == Net::HTTPSuccess
        @unwound_error = 'That url does not redirect!'
        @unwound_url = url
      else
        @unwind_error = 'An error occured accessing that url.'
      end
    rescue Exception => ex
      @unwind_error = 'An error occured accessing that url.'
    end
  end
end
