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

def read url
  response = HTTParty.get url
  Reader.new Nokogiri::HTML(response.body)
end

def doc
  @doc ||= read params[:url]
end

def paths
  @paths ||= params[:path].split(',').map(&:strip)
end

def json obj
  JSON.dump obj
end

get '/' do
  content_type 'application/json'
  return json({status: 'OK'}) if not params[:url]
  json paths.reduce({}) { |set, path| set.update Hash[path, doc.read(path)] }
end
