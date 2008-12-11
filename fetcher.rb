require 'downloader'

class Fetcher < Shoes::Widget
  
  def initialize(options = {})
    @s = stack { draw_arrow }
    @s.click do
      info "yooooo"
      @s.clear do
        para "the fuck?"
        info "hey!"
      end
    end
  end
  
  def draw_arrow
    image "down_arrow.png"
  end
  
  def red_x
    image "red-x.png"
  end
  
  def click
    info "what"
  end
  
end