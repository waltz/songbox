class Fetcher < Shoes::Widget
  
  def initialize(options = {})
    draw_arrow
  end
  
  def draw_arrow
    flow do
      width = 50
      translate width/2, width/2
      rotate 270
      arrow 0, 0, width
    end
  end
  
end