require 'rubygems'
require 'json'
require 'logger'

Log = Logger.new(STDOUT)
Log.level = Logger::DEBUG


class Argon

  def initialize(object, &block)
    @object = object
    yield(@object)
  end

end


class Object

  attr_accessor :capt, :level

  def argon(&block)
    @object = self
    @capt ||= {}
    block{ yield(@object) }
    puts @capt.to_json
  end

  def block(key=nil)
    $keys ||= []
    $keys.push(key).compact!
    $block_level ||= 0
    $block_level += 1
    r = yield
    $keys.pop
    $block_level -= 1
    r
  end

  def set_val(method, val)
    hash_accessors = [$keys, method].flatten.map{|k| "[:#{k}]" }
    compounded = ""
    hash_accessors.each do |h|
      compounded << h
      eval("@capt#{compounded} ||= {}") unless $keys.empty?
    end
    eval("@capt#{hash_accessors.join}=val if (@capt#{hash_accessors.join} == {} || @capt#{hash_accessors.join} == nil)") unless @capt.keys.include?(method.to_sym)
  end

  def add_node(node_name, value, &block)
    @object.set_val(node_name, block(node_name){ block_given? ? yield(@object) :  value })
  end

  def method_missing(method, *args, &block)
    add_node(method, args[0], &block)
  end

  def get_val(method)
    return self[method] || self.send(method.to_sym) rescue self.send(method.to_sym)
  end

  def node(method, options={})
    value =  get_val(method)
    add_node(method, value )
  end

end

@object = {:thing => "stuff", :id => 99, :cord => {:blood => "death"}}

@object.argon do |s|

  s.node :to_a

  wimp do
    s[:id]
  end

  putz do

    fuck do

      pip do

        dip do

          9999

        end

      end

    end

    suck do
      44
    end

  end

end

