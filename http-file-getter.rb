require 'net/http'
require 'uri'
require 'thread'

class Downloader
  attr_accessor :status, :url, :percent, :semaphore
  
  def initialize(url)
    self.url = url
    self.status = "set!"
    self.percent = 0
    semaphore = Mutex.new
  end
  
  def download
    uri = URI.parse(self.url)
    Net::HTTP.new(uri.host, uri.port) do |http|
      size = http.get_headers.content_length
      http.
      
    end
  end
end

Shoes.app do
  @downloader = Downloader.new("http://www.pandemicstudios.com/mercenaries/audio/Oh_No_Full_Length.mp3")
  
  @button = button "download" do
    @downloader.status = "triggered!"
  end
  
  @status = stack do
    para "status"
  end
end

