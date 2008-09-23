require 'seeqpod'

Shoes.app(:title => 'Songbox',
          :width => 450,
          :height => 500,
          :resizable => false) do
  
  def preview_widget(location)
    flow do
      t = title "not playing"
      v = video location
      v.hide
      button("play") { v.play }
      button("pause") { v.pause }
      every(1) do
        t.replace((v.time.to_i * 1000).to_s)
      end
    end
  end
  
  def download_widget(location)
    flow do
      p = progress(:width => 1.0)
      button "download" do
        info "Started: " + File.basename(location)
        download(location,
                 :save => File.basename(location),
                 :progress => proc { |dl| p.fraction = dl.percent * 0.01 },
                 :finish => proc { info "Finished: " + File.basename(location) })
      end
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
            #preview_widget(track.location)
            flow do
              v = video track.location
              v.hide
              button("play") { v.play }
              button("pause") { v.pause }
              t = para ""
              animate do
                t.replace((v.time.to_i * 0.001).to_s)
              end
            end
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

