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
            para track.title
            button "Download" do
              download(track.uri, :save => 'foo.mp3') do
                alert "Downloaded Finished"
              end
            end
          end
        end
      end
    end
  end
            
  background rgb(237, 227, 158)
  
  @search_box = flow(:width => 450, :height => 50) do
    background rgb(255, 93, 40)
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

