class Shoes::Cyclops < Shoes::Widget

  def initialize(opts = {})
    radius = opts[:radius] || 100
    stroke black
    fill white
    oval :radius => radius
  end

end