##
## skreemr.rb
##
## A search interface for SkreemR (http://skreemr.com).
##

require 'throbber'
require 'track'
require 'hpricot'
require 'getter'
require 'uri'

class Skreemr < Shoes::Widget
  # Grabs search results and return them as tracks.
  def initialize(args = {})
    # Show a loading throbber immediately.
    @results = flow do
      throbber :color => dodgerblue, :left => 100, :top => 15
    end

    # Wire up the downloader.
    download(url(args[:query]),
             :error => proc { |dl, err| display_error("Network problems!"); error("Error: #{err}"); return },
             :finish => proc { |dl| finished(dl) })
  end
  
  # Builds the query URL.
  def url(query, results_per_page = 10, offset = 0)
    "http://skreemr.com/results.jsp?q=#{URI.encode(query)}&l=#{results_per_page}&s=#{offset}"
  end
  
  # Called when the results are finished downloading.
  def finished(dl = nil)
    # Parse the document with Hpricot.
    doc = Hpricot(dl.response.body)
    
    # Fish for the tracks.
    tracks = doc.search(".info a.snap_noshots").map do |e|
      Track.new(:url => e[:href],
                :artist => e.search("span").inner_html.gsub(/\A[\s]*/, ''))          
    end
    
    # Pick out the url, artist and album.
    @results.clear do
      if tracks.size > 0
        tracks.each do |track|
          getter(:track => track)
        end
        flow(:height => 4) {}
      else
        display_error "Didn't find a thing."
      end
    end
  end
  
  # Show an error!
  def display_error(text = "Error!")
    @results.clear do
      stack do
        stroke red
        fill red
        rect(50, 50, 350, 75, 3)
        para text, :stroke => white, :size => 25, :align => "center", :top => 130
      end
    end
  end
end
