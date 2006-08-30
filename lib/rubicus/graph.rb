require 'tempfile'

module Rubicus
  
  # ==Rubicus Graph
  #
  # Author:: Jonathan Younger
  # Date:: August 24th, 2006
  #
  #
  # ====Graphs vs. Layers (Graph Types)
  #
  # Rubicus::Graph is the primary class you will use to generate your graphs.  A Graph does not
  # define a graph type nor does it directly hold any data.  Instead, a Graph object can be thought
  # of as a canvas on which other graphs are draw.  (The actual graphs themselves are subclasses of Rubicus::Layers::Base)
  # Despite the technical distinction, we will refer to Rubicus::Graph objects as 'graphs' and Rubicus::Layers as
  # 'layers' or 'graph types.'
  #
  #
  # ==== Creating a Graph
  #
  # You can begin building a graph by instantiating a Graph object
  #
  #   graph = Rubicus::Graph.new
  #
  # Once you have a Graph object you can begin adding graph layers.  
  # You can add a graph layer to a graph by using the Graph#add or Graph#<< methods.
  # The two methods are identical and used to accommodate syntax preferences.
  #
  #   graph.add :lines, [[10, 20], [20, 30], [30, 40], [40, 50]], :title => "Jack", :x => 1, :y => 2, :pointsym => :none, :rectangle => [1, 1, 3, 3]
  #   graph.add :lines, [[10, 20], [20, 30], [30, 40], [40, 50]], :title => "Jill", :x => 1, :y => 2, :pointsym => :none, :rectangle => [4, 1, 6, 3]
  #
  # Now that we've created our graph and added a layer to it, we're ready to render!  You can render the graph
  # directly to PNG or any other image format (supported by ploticus) with the Graph#render method:
  #
  #   # Defaults to PNG
  #   graph.render
  #
  #   # For image formats other than PNG:
  #   graph.render(:as => 'GIF')
  #
  #   # To render directly to a file:
  #   graph.render(:to => '<filename>')
  #
  #   graph.render(:as => 'GIF', :to => '<filename>')
  #
  # And that's your basic Rubicus graph!  Please check the ploticus documentation for the various methods and
  # classes you'll be using, as there are a bunch of options not demonstrated here.
  #
  # A couple final things worth noting:
  # * You can call Graph#render as often as you wish with different rendering options.  In
  #   fact, you can modify the graph any way you wish between renders.
  #
  #
  # * There are no restrictions to the combination of graph layers you can add.  It is perfectly
  #   valid to do something like:
  #     graph.add(:lines, [100, 200, 300])
  #     graph.add(:vbars, [200, 150, 150])
  class Graph
    attr_accessor :layers
    attr_accessor :default_type
    attr_accessor :options
    
    def initialize(options = {})
      @default_type = options.delete(:type)
      @options = options
      @layers ||= []
    end

    def <<(*args, &block)
      if args[0].kind_of?(Rubicus::Layers::Base)
        layers << args[0]
      else
        type = args.first.is_a?(Symbol) ? args.shift : @default_type
        data = args.first.is_a?(Array) ? args.shift : []
        options = args.first.is_a?(Hash) ? args.shift : {}
        
        raise ArgumentError, "You must specify a graph type (:scat, :lines, :pie, etc) if you do not have a default type specified." if type.nil?
        
        unless Rubicus::Layers.const_defined? to_camelcase(type.to_s)
          layer = Rubicus::Layers::Prefab.new(options.merge({ :prefab => type, :data => data }))
        else
          layer = Kernel::module_eval("Rubicus::Layers::#{to_camelcase(type.to_s)}").new(options.merge({ :data => data }), &block)
        end
        
        layers << layer
      end
      layer
    end
    
    alias :add :<<

    # Renders the graph in it's current state to an PNG object.
    #
    # Options:
    # as:: File format to render to ('PNG', 'JPG', etc)
    # to:: Name of file to save graph to, if desired.  If not provided, image is returned as blob/string.
    def render(options = {})
      options[:o] ||= "stdout"
      image_type = options.delete(:as) || "png"
      to = options.delete(:to)
      
      image = case layers.size
      when 0
        raise "You haven't specified any layers to render."
      when 1
        layers.first.draw(image_type, @options.merge(options))
      else
        dump_file = Tempfile.new("rubicus_dump_file")
        layers.each { |layer| layer.draw(nil, :drawdumpa => dump_file.path) }
        layer = Rubicus::Layers::Prefab.new(:prefab => :draw, :dumpfile => dump_file.path)
        layer.draw(image_type, @options.merge(options))
      end
      
      File.open(to, "w") { |file| file.write(image) } if to
      
      image
    end
    
    protected
    def to_camelcase(type)  # :nodoc:
      type.split("_").map { |e| e.capitalize }.join("")
    end
  end
end