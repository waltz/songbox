##
## track.rb
##
## Stores data about tracks.
##

require 'uri'
require 'digest/md5'

class Track
  
  attr_accessor :artist, :title, :url
  
  def initialize(args = {})
    @artist = args[:artist]
    @title = args[:title]
    @url = args[:url]
  end
  
  # Just the name of the file. (Not the full path.)
  def filename
    URI.decode(File.basename(@url))
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
      "#{filename}"
    end
  end
  
  # Nicely formatted filename.
  def formatted_filename
    name.downcase.strip.gsub(' ', '_').gsub(/\W/, '_').gsub('_', '-').gsub(/-{2,}/, '-')
  end
  
  def hash
    Digest::MD5.hexdigest(self.name).to_s
  end
end