require 'rubygems'
require 'json'
#require 'xml'
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

  attr_accessor :capt, :level, :format

  def argon(&block)
    @object = self
    @capt ||= {}
    block{ yield(@object) }
    @format = :json
    @capt
  end

  def render
    case format.to_sym
      when :json : @capt.to_json
      when :xml : @capt.to_xml
    end
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
      instance_eval("@capt#{compounded} ||= {}") unless $keys.empty?
    end
    instance_eval("@capt#{hash_accessors.join}=val if (@capt#{hash_accessors.join} == {} || @capt#{hash_accessors.join} == nil)") unless @capt.keys.include?(method.to_sym)
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

  def add(method, options={})
    value =  get_val(method)
    add_node(method, value )
  end

end

@hey = "soap"
@object = {:thing => "stuff", :id => 99, :cord => {:blood => "death"}}
@s = Time.now

100.times do |i|
  @object.argon do |s|

    s.add :to_a

    wimp do
      @hey
    end

    putz do
      fuck do
        pip do
          cord do
            s[:cord]
          end
        end
      end
      suck do
        44
      end
    end

  end

  puts @object.render

end

@f = Time.now

puts "Time was #{@f - @s}"