require 'net/http'
require 'uri'
require 'rexml/document'

# A Seeqpod user id so we can use their API.
USER_ID = "92b90c39b6fa07674f7b4f1ca07fc42ec33eda87"

module Songbox
  
  Track = Struct.new(:artist, :title, :location)
  
  def seeqpod_search(query, args = {})
    query = URI.escape(query)
    start_index = args[:start_index] || 0   # Default index is 0 unless previously set.
    num_results = args[:num_results] || 10  # Default is 10 unless...
    user_id = USER_ID
    uri = "http://www.seeqpod.com/api/v0.2/#{user_id}/music/search/#{query}/#{start_index}/#{num_results}/"
    
    data = Net::HTTP.get(URI.parse(uri))
    doc = REXML::Document.new(data)
    tracks = []
    
    doc.root.each_element('//track') do |track|
      location = URI.escape(track.elements[1].text)
      artist = track.elements[3].text
      title = track.elements[2].text
      tracks << Track.new(artist, title, location)
    end
    
    tracks
  end
  
  def preview_widget(location)
    flow do
      t = title "not playing"
      v = video location
      v.hide
      button("play") { v.play }
      button("pause") { v.pause }
      every(1) do
        t.replace((v.time.to_i * 1000).to_s)
      end
    end
  end
  
  def download_widget(location)
    flow do
      p = progress(:width => 1.0)
      button "Download" do
        download(location,
                 :save => File.basename(location),
                 :progress => proc { |dl| p.fraction = dl.percent * 0.01 })
      end
    end
  end
  
  # Asks Seeqpod for a list of results and formats them.
  def render_search(query, container)
    search_results = nil

    # Do the search asynchronously.
    search_thread = Thread.new do
      search_results = flow do
          seeqpod_search(query).each do |track|
            flow do
              para strong track.artist.to_s
              para em track.title.to_s
              #preview_widget(track.location)
              download_widget(track.location)
            end
          end
      end
    end
    
    search_results
  end
  
end

Shoes.app(:title => 'Songbox', :width => 450, :height => 500, :resizable => false) do
  
  extend Songbox
            
  background white

  @search_box = flow(:width => 450, :height => 50) do
    background black
    search_query = edit_line
    search_button = button("Search")
    search_button.click { render_search(search_query.text, @search_results_view) }
  end
  
  @search_results_view = flow { para "Go for it punk!" }
  
  stack do
    @search_box
    @search_results_view
  end
  
end
