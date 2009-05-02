require 'downloader'
require 'thread'

class Fetcher < Shoes::Widget
  
  def initialize(options = {})
    @url = options[:url]
    
    @container = flow(:height => 100, :width => 100) do
      para "Loading"
    end
    
    @state = :idle
    idle
    
    click do
      info "Click recieved."
      if @state == :idle
        @state = :downloading
        download
      end
    end
    
  end
  
protected
  
  def idle
    info "Idle action triggered."
    @container.clear do
      image "down_arrow.png"
    end
  end
  
  def error
    info "Error action triggered."
    @container.clear do
      image "red-x.png"
    end
  end
  
  def download
    info "Download action triggered."
    
    # Setup the mutex and variable.
    percent = 0
    percent_mutex = Mutex.new
    
    # Download the file and update the percent counter.
    download_thread = Thread.new do
      Downloader.new(@url).download do |i|
       percent_mutex.synchronize do
         percent = i
       end 
      end
    end
    
    # Render the progress circle.
    animate do
      @container.clear do
        percent_mutex.synchronize do
          draw_progress(percent)
        end
      end
    end
  end

  def info(msg)
    Shoes::info("Fetcher - #{self.object_id}: #{msg}")
  end
  
  def draw_progress(percent)
    yellow = rgb(238, 238, 17)
    orange = rgb(255, 117, 24)

    stroke gray
    fill white
    strokewidth 2
    
    oval 25, 25, 50, 50
    
    stroke orange
    fill white
    strokewidth 5
  
    start = -(Shoes::HALF_PI)
    stop = start + (Shoes::TWO_PI * percent)
    arc 50, 50, 50, 50, start, stop
    
    flow(:top => 38, :left => 0) do
      stroke gray
      inscription((percent * 100).truncate.to_s, :align => 'center')
    end
  end
  
end