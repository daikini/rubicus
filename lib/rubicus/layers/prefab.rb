module Rubicus::Layers
  class Prefab < Base
    def initialize(options = {})
      @type = options.delete(:prefab)
      @data = options.delete(:data)
      @options = options
      @options[:delim] ||= :comma
    end
    
    def draw(image_type = "png", options = {})
      options[image_type] = nil if image_type
      options[:prefab] ||= @type
      
      if @data
        data = if @data[0].kind_of? Array
          @data.map {|row| row.join(delimiter_for_delim(@options[:delim])) }.join("\n")
        else
          @data.join(",")
        end
      else
        data = nil
      end
      
      ploticus_options = options.map { |key, option| "-#{key} #{convert_options(option)}" }.join(" ")
      prefab_options = @options.map { |key, option| "#{key}=\"#{convert_options(option)}\"" }.join(" ")
      io = IO.popen("ploticus #{@data ? "data=stdin" : ""} #{ploticus_options} #{prefab_options}", "w+")
      if @data
        io.write data
        io.close_write
      end
      img = io.read
      io.close
      img
    end
    
    
    protected
    def delimiter_for_delim(delim)
      case delim
      when :comma
        ","
      when :tab
        "\t"
      else
        " "
      end
    end
  end
end