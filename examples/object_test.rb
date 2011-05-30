require "argo.rb"

@time = Time.now

@time.argon do |s|
  
  s.add_attributes :day, :month, :year
   
  event do 
    
    start do
       s.hour.to_s + "O'clock"
    end
    
    description do
      "Tennis with my sons friends"
    end
    
  end
  
end

puts @time.to_format(true)