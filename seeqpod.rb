require 'net/http'
require 'uri'
require 'rexml/document'

# Quick interface for Seeqpod.
class Seeqpod
  
  class Track < Struct.new(:title, :uri); end
  
  def self.search(query, args = {})
    start_index = args[:start_index] || 0   # Default index is 0 unless previously set.
    num_results = args[:num_results] || 10  # Default is 10 unless...
    user_id = "92b90c39b6fa07674f7b4f1ca07fc42ec33eda87"  
    uri = "http://www.seeqpod.com/api/v0.2/#{user_id}/music/search/#{query}/#{start_index}/#{num_results}/"
    
    data = Net::HTTP.get(URI.parse(uri))
    doc = REXML::Document.new(data)
    tracks = []
    
    doc.root.each_element('//track') do |track|
      #puts track.inspect
      uri = track.elements[1].text
      title = track.elements[2].text + " " + track.elements[3].text
      tracks << Track.new(title, uri)
    end
    
    tracks
  end
  
end