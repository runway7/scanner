require './scanner'  # <-- your sinatra app
require 'rspec'
require 'rack/test'
require 'json'

set :environment, :test

describe 'Scanner' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "gives a heartbeat" do
    get "/"
    last_response.should be_ok
  end

  it 'parses single paths' do
    response = mock(body: open('./testpages/nextweb.html'))
    HTTParty.should_receive(:get).with('nextweb').and_return(response)
    get '/?url=nextweb&path=title'
    JSON.parse(last_response.body)['title'].first['content'].should == "Amazing: Microsoft turns spoken English into spoken Mandarin - in the same voice - The Next Web"
  end

  it 'parses single paths' do
    response = mock(body: open('./testpages/nextweb.html'))
    HTTParty.should_receive(:get).with('nextweb').and_return(response)
    get "/?url=nextweb&path=title,#{URI.encode('meta[property="og:site_name"]')}"
    JSON.parse(last_response.body)['title'].first['content'].should == "Amazing: Microsoft turns spoken English into spoken Mandarin - in the same voice - The Next Web"
    JSON.parse(last_response.body)['meta[property="og:site_name"]'].first['attributes']['content'].should == "The Next Web"    
  end
end