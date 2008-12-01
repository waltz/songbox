class Fetcher < Shoes::Widget
  
  def initialize(options = {})
   flow :width => 50, :height => 50 do
     arrow
   end
  end
  
  def arrow
    stroke green
    fill green
    rotate 45
    arrow :width => 30    
  end
  
end