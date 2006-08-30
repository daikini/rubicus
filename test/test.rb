#/usr/bin/env ruby
require File.dirname(__FILE__) + '/../lib/rubicus'

data = [
  ["Name", "Concentration", "PeakArea"],
  ["A", 1, 2],
  ["B", 2, 3],
  ["C", 2, 4],
  ["D", 1, 4],
  ["E", 6, 7]
]

# layer = Rubicus::Layers::Scat.new(:data => data, :xgrid => { :width => "0.1", :color => "gray(0.9)"}, :x => 2, :y => 3, :corr => true)

g = Rubicus::Graph.new
g.add :scat, data, :xgrid => { :width => "0.1", :color => "gray(0.9)" }, :x => 2, :y => 3, :corr => true, :rectangle => [1, 1, 3, 3]
g.add :scat, data, :xgrid => { :width => "0.6", :color => "gray(2.5)" }, :x => 2, :y => 3, :corr => true, :rectangle => [4, 1, 6, 3]
# g.add layer
g.render(:to => "bob.png")



























layer = Rubicus::Layers::Custom.new

layer.data = [
    [2000, 750],
    [2010, 1700],
    [2015, 2000],
    [2020, 1800],
    [2025, 1300],
    [2030, 400]
  ]

layer.area {|a|
  a.title = "Social Security trust fund asset estimates, in $ billions\nhallo\nsuper"
  a.titledetails = {:adjust => "0,0.1"}
  a.rectangle = [1, 1, 5, 2]
  a.xrange = [2000, 2035]
  a.yrange = [0, 2000]
}

layer.xaxis {|a| 
  a.stubs = "inc 5"
  a.label = "Year"
}

layer.lineplot {|a|
  a.xfield = 1
  a.yfield = 2
 a.fill = "pink"
}

layer.lineplot {|a|
  a.xfield = 1
  a.yfield = 2
  a.fill = "rgb(.7,.3,.3)"
  a.linerange = [2010, 2020]
}

layer.lineplot {|a|
  a.xfield = 1
  a.yfield = 2
  a.linedetails = {:color => 'red'}
  a.fill = "rgb(.7,.3,.3)"
  a.linerange = [2010, 2020]
}

layer.yaxis {|a|
  a.stubs = "incremental 500"
  a.grid = {:color=> 'blue'}
  a.axisline = 'none'
}

g = Rubicus::Graph.new
g.add layer
g.render(:to => "bob2.png")








g = Rubicus::Graph.new
g.add :lines, [[10, 20], [20, 30], [30, 40], [40, 50]], :title => "Jack", :x => 1, :y => 2, :pointsym => :none, :rectangle => [1, 1, 3, 3]
g.add :lines, [[10, 20], [20, 30], [30, 40], [40, 50]], :title => "Jill", :x => 1, :y => 2, :pointsym => :none, :rectangle => [4, 1, 6, 3]
g.render :to => "hmm.png"







data = (1..12).collect { |i| ["Test #{i}", rand(110), rand(20)] }

g = Rubicus::Graph.new
g.add :vbars, data, :x => 1, :y => 2, :autow => false, :errunder => true, :ygrid => true, :barwidth => :line, :stubvert => true, :xaxis => :none, :yaxis => :none, :rectangle => [0, 0, 0.5, 0.2], :legend => false, :header => false, :yrange => 110
g.render(:to => "sweet.png")


# data = (1..12).collect { |i| [i, rand(20)] }
# 
# g = Rubicus::Graph.new
# g.add :line, data, :x => 1, :y => 2, :pointsym => :none, :xaxis => :none
# g.render(:to => "sweet.png")
