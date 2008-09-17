Shoes.app(:title => 'Songbox',
          :width => 350,
          :height => 400,
          :resizable => false) do
  
  background rgb(237, 227, 158)
  
  @search_box = flow do
    background rgb(255, 93, 40)
    edit_line(:width => 200).text = "Search"
    button "Search"
  end
  
  @search_results = flow do
    para "Nothing yet."
  end
  
  stack(:width => 350) do
    @search_box
    @search_results
  end

end