Shoes.app do
  @s = stack do
    para "hey"
  end
  
  @s.click do
    @s.clear do
      para "what"
    end
  end
end