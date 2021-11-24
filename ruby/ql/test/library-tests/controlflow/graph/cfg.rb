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

41 + 1

2.times { |x| puts x }

puts &:puts

Proc.new { |&x| x.call }

while true
  break 1
end

if false
  puts "impossible"
end

self.puts 42

case 10
  when 1 then puts "one"
  when 2, 3, 4 then puts "some"
  else puts "many"
end

case
  when b == 1 then puts "one"
  when b == 0, b > 1 then puts "some"
end

chained = "a" "#{chained}" "string"

character = ?\x40


# this is a class
class Silly < Object
  complex = 10-2i
  conditional = b < 10 ? "hello" : "bye"
  C = "constant"
  (x, (y, z)) = [1, [2, 3]]
  def pattern( (a,b) )
    puts a
    puts b
  end
  items = [1, 2, 3]
  puts items[2]
  def print() 
    puts "silly"
  end
end

x = 42
if x < 0 then 0 elsif x > 10 then 10 else x end

begin
  ; # empty statement
rescue Exception, Exception2 => e
  puts "oops"
  retry
else
  puts "ok"
ensure
  puts "end"
end

escape = "\u1234#{x}\n"

for x in [1.4, 2.5, 3.4e5] do
  if x > 3 then next end
  puts x
end

$global = 42

map1 = { 'a' => 'b', 'c': 'd', e: 'f' }
map2 = { **map1, 'x' => 'y', **map1}


def parameters(value = 42, key:, **kwargs)
  puts value
  return kwargs[key]
end

type  = "healthy"
table = "food"
puts (<<SQL)
SELECT * FROM #{table} \n
WHERE #{type} = true \n
SQL

puts "hi" if b > 10

class C 
  @field = 42
  @@static_field = 10
end

swap = ->((x, y)) { [y, x] }

module M
 nothing = nil
 some = 2
 some += 10
 last = (2; 4; 7)
 range = 0..9
 half = 1/3r + 1/6r
 regex = /hello\s+[#{range}]/
 Constant = 5
end

class EmptyClass; end
module EmptyModule; end

1/0 rescue puts "div by zero"

(*init, last) = 1, 2, 3

M::Constant
M.itself::Constant

class << Silly.itself
  def setter=() end
  def print()
    puts "singleton"
    puts super.print()
  end
end

silly = Silly.new
def silly.method(*x) 
  puts x
end

def two_parameters (a,b) end

two_parameters(*[1,2])

scriptfile = `cat "#{__FILE__}"`

symbol = :hello

delimited_symbol = :"goodbye-#{ 12 + 13 }"

x = true
x = ! true
x = - 42

undef two_parameters

unless x == 10 then puts "hi" else puts "bye" end
  
puts "hi" unless x == 0

until x > 10 do x += 10; puts "hello" end

i = 0
(puts "hello"; i += 1) until i == 10

x = 0
while x < 10 do
  x += 1
  if x == 5 then redo end
  puts x
end

(puts "hello"; i -= 1) while i != 0

def run_block
  yield 42
end

run_block { |x|puts x }

def forward_param(a, b, ...)
  bar(b, ...)
end

__END__

Some ignored nonsense

