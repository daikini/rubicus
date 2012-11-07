# Most of this code is from the ploticus.rb file by Mike Neumann http://www.ntecs.de/blog-old/Blog/RubyPloticus.rdoc

module Rubicus::Layers
  class Custom < Base
    def initialize
      reset!
    end

    def data=(rows)
      data {|a| a.data = rows }
    end

    def draw(image_type = "png", options = {})
      options[image_type] = nil if image_type
      ploticus_options = options.map { |key, option| "-#{key} #{convert_options(option)}" }.join(" ")
      io = IO.popen("ploticus -stdin #{ploticus_options}", "w+")
      io.write @s
      io.close_write
      img = io.read
      io.close
      img
    end

    def reset!
      @s = ""
    end

    PROCS = [ 
      [:data, :getdata],
      [:area, :areadef], 
    ]

    PROCS.each do |m, mp|
      mp ||= m
      eval %[ def #{ m }(&block) do_block("#{ mp }", &block) end ]
    end

    def method_missing(id, &block)
      do_block(id.to_s, &block)
    end

    private
    def do_block(mp, &block)
      @s << "#proc #{ mp }\n"
      AttrWriter.new(&block).__attrs__.each do |k, v|
        @s << "#{ k }: #{ convert(v) }\n"
      end
      @s << "\n"
    end

    class AttrWriter
      orig_verbosity, $VERBOSE = $VERBOSE, nil
      instance_methods.each { |m| undef_method m unless m =~ /^__/ }
      $VERBOSE = orig_verbosity

      def __attrs__
        @attrs
      end

      def initialize(&block)
        @attrs = {}
        block.call(self)
      end

      def method_missing(id, value)
        @attrs[id.to_s.gsub("=", "")] = value
      end
    end
  end
end