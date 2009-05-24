require 'getter'
require 'track'
require 'skreemr'

class Songbox < Shoes
  @@query = ""
  @@per_page = 10
  
  url '/', :index
  url '/page/(\d+)', :page
  
  def index
    search_header
    
    stack do
      stroke yellowgreen
      fill yellowgreen
      rect(25, 25, 400, 150, 3)
      
      stack(:top => 40, :left => 40) do
        banner "Welcome to Songbox!", :variant => "smallcaps", :stroke => white, :size => 28, :left => 40
        tagline "Find, download, and preview MP3's.", :stroke => whitesmoke, :size => 15, :left => 70
        para(link("Brought to you by Deep Yogurt.", :click => "http://deepyogurt.org"), :left => 110)
      end
    end
  end
  
  def page(page_number)
    search_header
        
    # Skreemr search box.
    skreemr(:query => @@query)
  end
  
  def search_header
    flow(:width => 450, :height => 65) do
      background gradient(rgb(50,50,50), black)
      query_editor = edit_line(:width => 310, :top => 15, :left => 15)
      search_button = button('Search', :width => 100, :top => 17, :left => 335) do
        # Pull the query from the text box and view the first page of results.
        @@query = query_editor.text
        visit('/page/1')
      end
    end
    background white
  end    
end

Shoes.app(:title => 'Songbox', :width => 450, :height => 500, :resizable => false)
