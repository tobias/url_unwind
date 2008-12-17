require 'rubygems'
require 'vendor/sinatra/lib/sinatra.rb'



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

helpers do
  def unwind(url, depth = 5)
    if url.nil? or url.empty?
      error = 'Please enter a url.'
    else
      begin
        response = Net::HTTP.get_response(URI.parse(url))
p response
        if response['location']
          to_url = response['location']
        elsif response.is_a?(Net::HTTPSuccess)
          error = 'That url does not redirect!'
          to_url = url
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
