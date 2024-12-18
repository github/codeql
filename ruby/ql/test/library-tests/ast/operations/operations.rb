# Start with assignments to all the identifiers used below, so that they are
# interpreted as variables.
a = 0
b = 0
bar = 0
base = 0
baz = 0
foo = 0
handle = 0
m = 0
mask = 0
n = 0
name = 0
num = 0
power = 0
qux = 0
w = 0
x = 0
y = 0
z = 0

# Unary operations
!a
not b
+14
-7
~x
defined? foo
def foo; return 1, *[2], a:3, **{b:4, c:5} end

# Binary arithmetic operations
w + 234
x - 17
y * 10
z / 2
num % 2
base ** power

# Binary logical operations
foo && bar
baz and qux
a or b
x || y

# Binary bitwise operations
x << 3
y >> 16
foo & 0xff
bar | 0x02
baz ^ qux

# Equality operations
x == y
a != 123
m === n

# Relational operations
x > 0
y >= 100
a < b
7 <= foo

# Misc binary operations
a <=> b
name =~ /foo.*/
handle !~ /.*bar/

# Arithmetic assign operations
x += 128
y -= 32
a *= 12
b /= 4
z %= 2
foo **= bar

# Logical assign operations
 x &&= y
 a ||= b

 # Bitwise assign operations
 x <<= 2
 y >>= 3
 foo &= mask
 bar |= 0x01
 baz ^= qux

class X
  @x = 1
  @x += 2

  @@y = 3
  @@y /= 4
end

$global_var = 5
$global_var *= 6

CONSTANT1 = 5
CONSTANT2 += 6
CONSTANT3 ||= 7
Foo::MemberConstant ||= 8
foo(1).bar::OtherConstant ||= 7
::CONSTANT4 ||= 7
FOO, ::BAR, foo::FOO = [1, 2, 3]

foo /
5