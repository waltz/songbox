require 'downloader'

class Fetcher < Shoes::Widget
  
  def initialize(options = {})
    @url = options[:url]
    
    @container = flow {
      para "Loading"
    }
    
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
    # begin
    #   downloader = Downloader.new(@url)
    #   downloader.download do |percent|
    #     @container.clear do
    #       draw_progress(percent)
    #     end
    #   end
    # rescue
    #   error
    # end
    @container.clear do
      draw_progress(0.35)
    end
  end

  def info(msg)
    Shoes::info("Fetcher Widget - #{self.object_id}: #{msg}")
  end
  
  def draw_progress(percent)
    yellow = rgb(238, 238, 17)
    stroke yellow
    nofill
    strokewidth 5
    start = -(HALF_PI)
    stop = start + (TWO_PI * percent)
    # para @percent
    # para @i
    arc 50, 50, 50, 50, start, stop
  end
  
end