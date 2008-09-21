require 'seeqpod'

Shoes.app(:title => 'Songbox',
          :width => 450,
          :height => 500,
          :resizable => false) do
  
  def search(query = "")
    @search_results.clear do
      flow do
        Seeqpod.search(query).each do |track|
          flow do
            strong track.artist
            em track.title
            p = progress :width => 1.0
            button "Download" do
              info "Download Started! " + track.uri
              download(track.uri,
                       :save => File.basename(track.uri),
                       :progress => proc { |dl| p.fraction = dl.percent * 0.01 },
                       :finish => proc { info "Finished: " + File.basename(track.uri) })
            end
          end
        end
      end
    end
  end
            
  background white
  
  @search_box = flow(:width => 450, :height => 50) do
    background black
    scroll false
    
    @search_query = edit_line(:width => 200)
    
    @search_go = button("Search")
    @search_go.click { search(@search_query.text) }
  end
  
  @search_results = flow { para "Go for it punk!" }
  
  # Draw the interface.
  stack do
    @search_box
    @search_results
  end
  
end

