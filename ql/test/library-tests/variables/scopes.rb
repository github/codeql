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
   a, b, (c, d) = [4, 5, [6, 7]]
   puts a # local variable from top-level
   puts b # new local variable
   puts c # new local variable
   puts d # new local variable
end

# new global variable
$global = 42

# use of a pre-defined global variable
script = $0
