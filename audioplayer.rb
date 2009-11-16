class Audioplayer < Shoes::Widget
  def initialize(args = {})
    # An almost-invisible video object to play the mp3.
    flow(:height => 1, :width => 1) do
      @player = video args[:filename]
    end

    # Build a flow for displaying info.
    @display = flow {}
    
    # Jump to the default state.
    default_state
  end

  private
  
  # Show the play button. Underline the play button on hover. Start the player on click.
  def default_state
    @display.clear do
      hover do
        debug("hover")
        @text.underline = "single" 
      end
      click { @player.play; show_time_counter }
      leave do
        debug("leave")
        @text.underline = "none"
      end
      
      @text = para "Play", :stroke => dodgerblue, :size => 15, :underline => "none"
    end
  end
  
  def show_time_counter
    @display.clear do
      hover do
        @time.hide
        @text.show
      end
      click do
        @player.stop
        default_state
      end
      leave do
        @text.hide
        @time.show
      end
      
      animate(10) do
        if @player.playing?
          @time.text = format_msec(@player.time)
        else
          default_state
        end
      end
      
      @time = para "0:00", :stroke => rgb(175, 31, 123), :size => 15
      @text = para "Stop", :stroke => dodgerblue, :size => 15, :hidden => true
    end
  end
  
  def show_stop_button
    @display.clear do
      hover {}
      click { @player.stop; default_state }
      leave { show_time_counter }
      
      para "Stop", :stroke => dodgerblue, :size => 15
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
