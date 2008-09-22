require 'seeqpod'

Shoes.app(:title => 'Songbox',
          :width => 450,
          :height => 500,
          :resizable => false) do
  
  def preview_widget(location)
    v = video(location)
    v.hide
    
    play = proc do
      button "play" do
        v.play
        l = pause
      end
    end
    
    pause = proc do
      button "pause" do
        v.pause
        l = play
      end
    end
    
    l = play
  end
  
  def download_widget(location)
    p = progress :width => 1.0
    button "download" do
      info "Started: " + File.basename(location)
      download(location,
               :save => File.basename(location),
               :progress => proc { |dl| p.fraction = dl.percent * 0.01 },
               :finish => proc { info "Finished: " + File.basename(location) })
    end
  end
  
  def search(query = "")
    @search_results.clear do
      flow do
        Seeqpod.search(query).each do |track|
          info "Showing: " + track.artist.to_s + " " + track.title.to_s
          flow do
            para strong track.artist.to_s
            para em track.title.to_s
            preview_widget(track.location)
            download_widget(track.location)
          end
        end
      end
    end
  end
            
  background white
  
  search_box = flow(:width => 450, :height => 50) do
    background black
    search_query = edit_line(:width => 200)
    search_go = button("Search")
    search_go.click { search(search_query.text) }
  end
  
  @search_results = flow { para "Go for it punk!" }
  
  stack do
    search_box
    @search_results
  end
  
end

