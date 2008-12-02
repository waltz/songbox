Shoes.app do
  @stack = stack do
    para "Nothing."
  end
  
  animate 30 do |i|
    @stack.clear do
      para i
    end
  end
end