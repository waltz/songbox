class Throbber < Shoes::Widget
  def initialize(args = {})
    color = args[:color] || black

    strokewidth 5
    stroke color
    fill color
    cap :curve
    
    @throbber = flow {}
    
    animate(30) do |frame|
      @throbber.clear do
        rotate 20
        line args[:left].to_i + 4, args[:top].to_i + 20, args[:left].to_i + 34, args[:top].to_i + 20        
      end
    end
  end
end