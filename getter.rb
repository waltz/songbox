require 'audioplayer'

class Getter < Shoes::Widget
  SAVE_PREFIX = './mp3s/' # Be sure to include the trailing slash!
  
  def initialize(args = {})
    @color = args[:color] || gray
    @track = args[:track]
    
    flow(:width => 435, :margin_top => 4, :margin_left => 4, :margin_right => 4) do
      flow(:width => 370) do
        background rgb(175, 31, 123)
        para @track.name, :size => 15, :stroke => white
      end
      
      flow(:width => 53) do
        @toolbox = flow {}
        
        # Start with the downloader state.
        downloader
      end
    end
  end
  
  def downloader
    @toolbox.clear do
      click { progress }
      # hover { @toolbox.clear { para "H" } }
      # leave { @toolbox.clear { para "G" } }

      para "Fetch", :stroke => rgb(175, 31, 123), :size => 15
    end
  end
  
  def progress
    @toolbox.clear do
      @progress = para "0%", :stroke => rgb(175, 31, 123), :size => 15
      
      # Reset mouse event handlers.
      click {}; hover {}; leave {}
      
      download(@track.url,
               :save      => @track.hash,
               :progress  => proc { |d| @progress.text = "#{d.percent}%" },
               :finish    => proc { insert_player },
               :error     => proc { |d, err| failure(err) })
    end
  end
  
  def failure(err = nil)
    @toolbox.clear do
      para "SHIT"
      error "Download failed: #{err}"
    end
  end
  
  def insert_player
    @toolbox.clear do
      audioplayer(:filename => @track.filename)
    end
  end
end
