#/usr/bin/env ruby
require File.dirname(__FILE__) + '/../lib/rubicus'

layer = Rubicus::Layers::Custom.new

layer.data = (0..10).map {|x| [x, x**2]}

layer.area {|a|
  a.title = "The title of this plot"
  a.xrange = [0,10]
  a.yrange = [0,100]
}

layer.xaxis {|a|
  a.stubs = "incremental"
  a.label = "x"
}

layer.yaxis {|a|
  a.stubs = "incremental 10"
  a.label = "x^2"
  a.grid = {:color => "blue"}
}

layer.lineplot {|a|
  a.xfield = 1    # use first column for x
  a.yfield = 2    # use second column for y
  a.linedetails = {:color => "red"}
}

g = Rubicus::Graph.new
g.add layer
g.render(:to => "bob.png")