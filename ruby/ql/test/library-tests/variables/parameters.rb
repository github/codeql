1.times do | x ; y|
   y = 5
   puts x
   puts y
end

def order_pizza(client, *pizzas)
  if pizzas.count == 1 
    puts "1 pizza for #{client}!"
  else
    puts "#{ pizzas.count} pizzas for #{client}!"
  end 
end 

def print_map(**map)
  map.each do |key, value|
    puts "#{key} = #{value}"
  end
end

def call_block(&block)
  block.call
end

def opt_param(name = 'unknown', size = name.length)
  puts name
  puts size  
end

def key_param(first: , middle: '', last:)
  puts "#{first} #{middle} #{last}"
end

b = 2
def multi(a = (b = 5))
  # `a` is a parameter and `b` is a new variable
  puts "#{a} #{b}"
end

def multi2(d: e = 4)
  # `d` is a parameter and `e` is a local variable
  puts "#{d} #{e}"
end

def dup_underscore(_,_)
  puts _ # binds to the first _
end

def tuples((a,b))
  puts "#{a} #{b}"
end

x = 10
1.times do | y = (x = 1)|
   puts x
   puts y
end

def tuples_nested((a,(b,c)))
  puts "#{a} #{b} #{c}"
end

