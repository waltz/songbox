class Audioplayer < Shoes::Widget
  def initialize(args = {})
    flow(:height => 1, :width => 1) do
      @player = video args[:filename]
    end

    @display = flow {}
    
    default_state
  end

  def default_state
    @display.clear do
      hover { debug("hover");@text.style(:stroke => dodgerblue, :underline => "single") }
      click { @player.play; show_time_counter }
      leave { debug("leave");@text.style(:stroke => rgb(175, 31, 123), :underline => "none") }
      
      @text = para "Play", :stroke => rgb(175, 31, 123), :size => 15
    end
  end
  
  def show_time_counter
    @display.clear do
      hover { show_stop_button }
      click {}
      leave {}
      
      animate(10) do
        if @player.playing?
          @time.text = format_msec(@player.time)
        else
          default_state
        end
      end
      
      @time = para "0:00", :stroke => rgb(175, 31, 123), :size => 15
    end
  end
  
  def show_stop_button
    @display.clear do
      hover {}
      click { @player.stop; default_state }
      leave { show_time_counter}
      
      para "Stop", :stroke => dodgerblue, :size => 15, :underline => "single"
    end
  end
  
  # Takes in some integer of milliseconds and formats it as minutes:seconds
  def format_msec(msecs)
    seconds = msecs / 1000
    minutes = seconds / 60
    seconds = seconds - (minutes * 60)    
    "#{minutes}:#{seconds.to_s.rjust(2, '0')}"
  end
end
