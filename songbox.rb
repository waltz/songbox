require 'getter'
require 'track'
require 'skreemr'

# Directory to store downloaded MP3's.
# - Must include trailing slash.
# - Can only be a single directory.
$STORAGE_DIRECTORY = 'mp3s/'

class Songbox < Shoes
  @@query = ""
  @@per_page = 10
  
  url '/', :index
  url '/page/(\d+)', :page
  
  def index
    begin
      check_or_create_directory($STORAGE_DIRECTORY)
    rescue RuntimeError => e
      alert(e.message)
      exit
    end

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
      
      # Start the search when the enter key is pressed.
      keypress do |k|
        if k == "\n"
          debug k.inspect
          goto_first_page
        else
          @query_editor.focus
        end
      end
        
      @query_editor = edit_line(:width => 310, :top => 15, :left => 15)
      # TODO: Set neat bands as the default search.
      # @query_editor.text = ["Matt Fox", "Jacob Berendes", "The Terribles", "Bone Zone", "Opposites Day"][rand(5)]
      @query_editor.focus
      # @query_editor.change { |k| debug k.text.inspect }
      if @@query then @query_editor.text = @@query end
      
      search_button = button('Search', :width => 100, :top => 17, :left => 335) do
        goto_first_page
      end
    end
    background white
  end
  
  def goto_first_page
    @@query = @query_editor.text
    visit '/page/1'
  end
  
  def check_or_create_directory(dir)
    if File.exists?(dir.gsub('/', ''))
      if File.directory?(dir)
        if File.writable?(dir)
          return
        else
          raise "Data storage directory is unwritable."
        end
      else
        raise "Data storage path exists but is not a directory. Remove or rename the file \"#{dir}\"."
      end
    else
      # Try to create the directory.
      begin
        Dir.mkdir(dir)
      rescue Errno::ENOENT => e
        raise "There was an error creating the storage directory: #{e.inspect}"
      end
    end
  end
end

Shoes.app(:title => 'Songbox', :width => 450, :height => 500, :resizable => false)
