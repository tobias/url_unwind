require 'rubygems'
require 'vendor/sinatra/lib/sinatra.rb'
require 'vendor/sinatra/lib/sinatra/test/unit.rb'
require 'urlunwind.rb'

class UrlunwindTest < Test::Unit::TestCase
  def test_index
    get_it '/'
    assert_match /Unwind It/, @response.body
  end

  def test_unwind_with_blank_url
    post_it '/unwind', :url => ''
    assert_match /Please enter/, @response.body
  end

  def test_unwind_with_valid_redir
    post_it '/unwind', :url => 'http://tinyurl.com/8kp'
    assert_match %r{http://google.com/}, @response.body
  end

  def test_unwind_with_bogus_url
    post_it '/unwind', :url => 'this_will_fail'
    assert_match /An error/, @response.body
  end

  def test_unwind_with_whitespaced_url
    post_it '/unwind', :url => 'http://tinyurl.com/8kp '
    assert_match %r{http://google.com/}, @response.body

    post_it '/unwind', :url => ' http://tinyurl.com/8kp'
    assert_match %r{http://google.com/}, @response.body

    post_it '/unwind', :url => "\thttp://tinyurl.com/8kp\n"
    assert_match %r{http://google.com/}, @response.body
  end

  def test_unwind_get_with_json
    get_it '/unwind.json', :url => 'http://tinyurl.com/8kp'
    assert_match %r{http:\\/\\/google.com\\/}, @response.body
  end
end
