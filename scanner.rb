require 'sinatra'
require 'httparty'
require 'nokogiri'
require 'json'

class Reader
  def initialize doc
    @doc = doc
  end

  def read path
    [@doc.css(path)].flatten.map do |element|
      {
        html: element.to_s,
        content: element.content,
        attributes: element.attributes
      }
    end
  end
end

def read link
  response = HTTParty.get link
  Reader.new Nokogiri::HTML(response.body)
end

def doc
  @doc ||= read link
end

def paths
  @paths ||= params[:path].split(',').map(&:strip) rescue []
end

def json obj
  JSON.dump obj
end

def homepage
  {
    status: 'OK',
    source: 'https://github.com/runway7/scanner'
  }.merge usage
end

def link
  params[:url].strip rescue ''
end

def usage
  {
    usage: 'http://scanner.runway7.net?url={{url}}&paths={{paths}}',
    details: 'Make sure the {{url}} has the scheme (http or https), and that the {{paths}} are comma separated. And your framework should do this automatically, but URL encode everything. Especially `#` characters in your paths.'
  }
end

get '/' do
  content_type 'application/json'  
  return json homepage if link.empty? and paths.empty?
  return json usage if link.empty? or paths.empty?
  json paths.reduce({}) { |set, path| set.update Hash[path, doc.read(path)] }
end
