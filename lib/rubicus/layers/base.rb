module Rubicus::Layers
  class Base
    protected
    def convert_options(obj)
      case obj
      when String
        obj.gsub("\n", "\\n")
      when Array
        if obj[0].kind_of? Array
          obj.map { |row| row.join(" ") }.join
        else
          obj.join(" ")
        end
      when Hash
        obj.map { |k,v| "#{k}=#{convert_options(v)}" }.join(" ")
      when true
        'yes'
      when false
        'no'
      else
        obj.to_s
      end
    end
  
    def convert(obj)
      case obj
      when String
        obj.gsub("\n", "\\n") + "\n"
      when Array
        if obj[0].kind_of? Array
          obj.map {|row| row.join(" ") + "\n"}.join
        else
          obj.join(" ")
        end
      when Hash
        obj.map {|k,v| "#{ k }=#{ convert(v) }" }.join(" ")
      when true
        'yes'
      when false
        'no'
      else
        obj.to_s
      end
    end
  end
end