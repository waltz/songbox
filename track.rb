##
## track.rb
##
## Stores data about tracks.
##

require 'uri'

class Track
  
  attr_accessor :artist, :title, :location
  
  def initialize(args = {})
    @artist = args[:artist]
    @title = args[:title]
    @location = args[:location]
  end
  
  # Just the name of the file. (Not the full path.)
  def filename
    URI.decode(File.basename(location))
  end

  # Format track names nicely.
  def name
    if artist and title
      "#{artist} - #{title}"
    elsif artist
      "#{artist}"
    elsif title
      "#{title}"
    else
      "No title found."
    end
  end
  
end