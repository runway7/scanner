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

  def json
    JSON.parse last_response.body
  end

  it "gives a heartbeat" do
    get "/"
    json['status'].should == 'OK'

    get '/?url=something'
    json['usage'].should_not be_nil
  end

  it 'parses single paths' do
    response = mock(body: open('./testpages/nextweb.html'))
    HTTParty.should_receive(:get).with('nextweb').and_return(response)
    get '/?url=nextweb&path=title'
    json['title'].first['content'].should == "Amazing: Microsoft turns spoken English into spoken Mandarin - in the same voice - The Next Web"
  end

  it 'parses single paths' do
    response = mock(body: open('./testpages/nextweb.html'))
    HTTParty.should_receive(:get).with('nextweb').and_return(response)
    get "/?url=nextweb&path=title,#{URI.encode('meta[property="og:site_name"]')}"
    json['title'].first['content'].should == "Amazing: Microsoft turns spoken English into spoken Mandarin - in the same voice - The Next Web"
    json['meta[property="og:site_name"]'].first['attributes']['content'].should == "The Next Web"    
  end
end