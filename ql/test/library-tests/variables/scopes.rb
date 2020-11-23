def a ; "x" end
1.times do | x |
   puts a # not a local variable
   a = 3
   puts a # local variable
end
a = 6
puts a
1.times do | x |
   puts a # local variable from top-level
   a = 3
   puts a # local variable from top-level
end