require 'thread'

Shoes.app do
  background white
  
  @portal = flow do
    para "portal"
  end
  
  @steps = Float(125)
  @i_mutex = Mutex.new 
  @i = 78
  
  counter = Thread.new do
    125.times do |x|
      sleep 1
      @i_mutex.synchronize do
        @i = x
      end
    end
  end
  
  animate do
    @portal.clear do
      yellow = rgb(238, 238, 17)
      stroke yellow
      nofill
      strokewidth 5
      
      @i_mutex.synchronize do
        @percent = (@i / @steps)
      end
        
      start = -(HALF_PI)
      stop = start + (TWO_PI * @percent)
      para @percent
      para @i
      arc 50, 50, 50, 50, start, stop
    end
  end
  
end