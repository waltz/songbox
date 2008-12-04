Shoes.app do
  @t = para "not playing"
  stack do
    @v = video "http://thetapeisnotsticky.com/uploads/2008/09/kids-soulwax-remix.mp3"
  end
  # @v.hide
  button("play") {@v.play}
  button("stop"){@v.stop}
  animate do
    @t.replace((@v.time*0.001).to_s)
  end
end