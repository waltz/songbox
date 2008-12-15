class Toggle < Shoes::Widget
  
end


Shoes.app do
  @state = "off"
  
  def toggle
    if @state == "off"
      @state = "on"
      para "yadda"
    else
      @state = "off"
      para "wanker"
    end
  end

  @s = stack do
    para "hey"
  end
  
  @s.click do
    @s.clear do
      toggle
    end
  end
end