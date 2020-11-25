def bar; end

alias foo bar

b = 42

%I(one#{ b } another) # bare symbol

%W(one#{ b } another) # bare string


begin 
  puts 4
end

BEGIN {
  puts "hello"
}

END {
  puts "world"
}
