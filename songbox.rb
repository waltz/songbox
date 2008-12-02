require 'net/http'
require 'uri'
require 'rexml/document'
require 'fetcher'

Shoes.app(:title => 'Songbox', :width => 450, :height => 500, :resizable => false) do
  
  def render_search(query, slot)
    search_thread = Thread.new do
      flow do
        seeqpod_search(query).each do |track|
          flow(:margin => 20) do
            para(strong(track.artist.to_s))
            para(em(track.title.to_s))
            #preview_widget(track.location)
            download_widget(track.location)
          end
        end
      end
    end
    
    slot.clear { search_thread.value }
  end
  
  def seeqpod_search(query, args = {})
    query = URI.escape(query)
    start_index = args[:start_index] || 0   # Default index is 0 unless previously set.
    num_results = args[:num_results] || 10  # Default is 10 unless...
    user_id = "92b90c39b6fa07674f7b4f1ca07fc42ec33eda87"
    uri = "http://www.seeqpod.com/api/v0.2/#{user_id}/music/search/#{query}/#{start_index}/#{num_results}/"
    
    data = Net::HTTP.get(URI.parse(uri))
    doc = REXML::Document.new(data)
    tracks = []
    
    doc.root.each_element('//track') do |track|
      location = URI.escape(track.elements[1].text)
      artist = track.elements[3].text
      title = track.elements[2].text
      tracks << Track.new(:artist => artist, :title => title, :location => location)
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
      p = progress(:width => 0.75, :margin => 5)
      button "Download" do
        download(location,
                 :save => File.basename(location),
                 :progress => proc { |dl| p.fraction = dl.percent * 0.01 }) do |file|
                   info file.response.methods
                 end
      end
    end
  end
  
  ###
  ### Real app code.
  ###
         
  background white

  stack do
    flow(:width => 450) do
      background black
      @search_box = flow(:width => 450, :height => 55, :margin => 10) do
        query = edit_line(:width => 310, :left => 0)
        search_button = button("Search", :width => 100, :left => 325) do
          render_search(query.text, @search_results)
        end
      end
    end
    
    flow(:width => 450) do
      @search_results = flow do
        #cyclops :radius => 20
      end
    end
  end
  

end
