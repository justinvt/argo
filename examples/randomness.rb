require "argo.rb"

### ASSUME WE ARE STARTING WITH AN OBJECT CALLED @object ###
### WHICH IS REALLY JUST A HASH, DEFINED AS SUCH....     ###

@object = {
  :type => "hat", 
  :description => "one of those stupid fedoras", 
  :id => 99, 
  :in_stock => 0, 
  :price => {
    :cost => 44.25, 
    :tax => 3.45 
  }
}



### This is how we'd use argon to pluck out and rearrange whatever
### aspects of @object we want to present to the consumers of our API

@object.argon do |s|
  
  ### |s| is our way to refer to @object from within this block
  
  s.attributes :type, :id, :in_stock => "do we have it?"
  
  ###  s.attributes is a quick way of saying,

  ###     "I don't want to waste a whole block, I just want to show a value from @object
  ###      as is, with nothing fancy""
  
  ###     attributes works two different ways:
  
  ###     s.attributes  :id                   ----->   {id:         "1234"}
  ###     s.attributes  :id => :product_id    ----->   {product_id: "1234"}
  
  ### The latter is just a tool to allow you to rename attributes/values/methods
  ### if you don't like the original names, or don't want to expose them to outsides.

  description do
    
    ### Above we created a "description" node.  Any blocks initialized within here will
    ### be buried inside the d
    
    summary do 
      
      "This is a #{s[:type]} referred to by many as \'#{s[:description]}\'"
    
    end
    
    price do 
      
      "$" + s[:price][:cost].to_s + ( s[:price][:tax] ? " (tax additional)" : "")
      
    end
    
    stocked do
      
      s[:in_stock] > 0 ? "item is in stock" : "item is sold out"
      
    end
    
  end

end

puts @object.to_format(true) # passing 'true' to to_format prettifies the output
