require 'rubygems'
require 'json'


# Here for posterity - no, i might go back and refactor
=begin
class Argon

  def initialize(object, &block)
    @object = object
    yield(@object)
  end

end
=end




class Object
  
  $capt = {}
  
  def logs(method_name)
    puts "Running #{method_name.to_s} - $capt = #{$capt.inspect} / @format - #{@format.inspect}"
  end

  attr_accessor  :level, :format

  def argon(&block)
    @object = self
    block{ yield(self) }
    @format = :json
    $capt
  end

  def to_format(pretty=nil)
    case format.to_sym
      when :json : pretty ?  JSON.pretty_generate($capt) : $capt.to_json
      when :xml : $capt.to_xml
    end
  end
  
  def accepts?(key)
    self.is_a?(Hash) && self.has_key?(key) && self[key]
  end

  def block(key=nil)
    $keys ||= []
    $block_level ||= 0
    $keys.push(key).compact!
    $block_level += 1
    r = yield(self)
    $keys.pop
    $block_level -= 1
    r
  end

  def set_val(method, val)
    hash_accessors = [$keys, method].flatten.map{|k| "[:#{k.to_s}]" }
    compounded = ""
    hash_accessors.each do |h|
      compounded << h
      instance_eval("$capt#{compounded} ||= {}") unless $keys.empty?
    end
    instance_eval("$capt#{hash_accessors.join}=val") unless $capt.keys.include?(method.to_sym) || val.nil?
  end
  
  def add_node(node_name, value, &block)
    if block_given?
      self.set_val(node_name, block(node_name){ yield(self) })
    else
      self.set_val(node_name, value )
    end
  end


  def get_attribute_or_method(method, *args)
    (args.to_a.empty? ? self.send( method.to_sym) : self.send( method.to_sym, *args ) ) || self.accepts?(method)
  end
  
  def add_attributes(*args)
    args.to_a.each do |arg|
      if arg.is_a?(String) || arg.is_a?(Symbol)
        add_node( arg, get_attribute_or_method(arg) )
      elsif arg.is_a?(Hash)
        add_node( arg.values.first, get_attribute_or_method(arg.keys.first) )
      end
    end
  end
  alias_method :add_attribute, :add_attributes
  
  def method_missing(method, *args, &block)
    if block_given?
      add_node(method, args[0]){ yield }
    else
      add_node(method, args[0])
    end
    return
  end

end
