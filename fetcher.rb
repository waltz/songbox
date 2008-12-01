class Fetcher < Shoes::Widget
  
  def initialize(options = {})
    draw_arrow
  end
  
  def draw_arrow
    # fill orange
    translate 50, 50
    rotate 270
    arrow 0, 0, 25    
  end
  
end