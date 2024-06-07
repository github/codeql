# call with no receiver, arguments, or block
foo()

# call whose name is a scope resolution
Foo::bar()

# call with a receiver, no arguments or block
123.bar

# call with arguments
foo 0, 1, 2

# call with curly brace block
foo { |x| x + 1 }

# call with do block
foo do |x|
  x + 1
end

# call with receiver, arguments, and a block
123.bar('foo') do |x|
  x + 1
end

# a yield call
def method_that_yields
  yield
end

# a yield call with arguments
def another_method_that_yields
  yield 100, 200
end

# ------------------------------------------------------------------------------
# Calls without parentheses or arguments are parsed by tree-sitter simply as
# `identifier` nodes (or `scope_resolution` nodes whose `name` field is an
# `identifier), so here we test that our AST library correctly represents them
# as calls in all the following contexts.

# root level (child of program)
foo
X::foo

# in a parenthesized statement
(foo)
(X::foo)

# in an argument list
some_func(foo)
some_func(X::foo)

# in an array
[foo]
[X::foo]

# RHS of an assignment
var1 = foo
var1 = X::foo

# RHS an operator assignment
var1 += bar
var1 += X::bar

# RHS assignment list
var1 = foo, X::bar

# in a begin-end block
begin
  foo
  X::foo
end

# in a BEGIN block
BEGIN { foo; X::bar }

# in an END block
END { foo; X::bar }

# both operands of a binary operation
foo + X::bar

# unary operand
!foo
~X::bar

# in a curly brace block
foo() { bar; X::baz }

# in a do-end block
foo() do
  bar
  X::baz
end

# the receiver in a call can itself be a call
foo.bar()
bar.baz()

# the value for a case expr
# and the when pattern and body
case foo
when bar
  baz
end
case X::foo
when X::bar
  X::baz
end

# in a class definition
class MyClass
  foo
  X::bar
end

# in a superclass
class MyClass < foo
end
class MyClass2 < X::foo
end

# in a singleton class value or body
class << foo
  bar
end
class << X::foo
  X::bar
end

# in a method body
def some_method
  foo
  X::bar
end

# in a singleton method object or body
def foo.some_method
  bar
  X::baz
end

# in the default value for a keyword parameter
def method_with_keyword_param(keyword: foo)
end
def method_with_keyword_param2(keyword: X::foo)
end

# in the default value for an optional parameter
def method_with_optional_param(param = foo)
end
def method_with_optional_param2(param = X::foo)
end

# in a module
module SomeModule
  foo
  X::bar
end

# ternary if: condition, consequence, and alternative can all be calls
foo ? bar : baz
X::foo ? X::bar : X::baz

# if/elsif/else conditions and bodies
if foo
  wibble
elsif bar
  wobble
else
  wabble
end
if X::foo
  X::wibble
elsif X::bar
  X::wobble
else
  X::wabble
end

# if-modifier condition/body
bar if foo
X::bar if X::foo

# unless condition/body
unless foo
  bar
end
unless X::foo
  X::bar
end

# unless-modifier condition/body
bar unless foo
X::bar unless X::foo

# while loop condition/body
while foo do
  bar
end
while X::foo do
  X::bar
end

# while-modifier loop condition/body
bar while foo
X::bar while X::foo

# until loop condition/body
until foo do
  bar
end
until X::foo do
  X::bar
end

# until-modifier loop condition/body
bar until foo
X::bar until X::foo

# the collection being iterated over in a for loop, and the body
for x in bar
  baz
end
for x in X::bar
  X::baz
end

# in an array indexing operation, both the object and the index can be calls
foo[bar]
X::foo[X::bar]

# interpolation
"foo-#{bar}-#{X::baz}"

# the scope in a scope resolution
foo::Bar
X::foo::Bar

# in a range
foo..bar
X::foo..X::bar

# the key/value in a hash pair
{ foo => bar, X::foo => X::bar }

# rescue exceptions and ensure
begin
rescue foo
ensure bar
end
begin
rescue X::foo
ensure X::bar
end

# rescue-modifier body and handler
foo rescue bar
X::foo rescue X::bar

# block argument
foo(&bar)
foo(&X::bar)
foo(&)
# splat argument
foo(*bar)
foo(*X::bar)
foo(*)

# hash-splat argument
foo(**bar)
foo(**X::bar)
foo(**)

# the value in a keyword argument
foo(blah: bar)
foo(blah: X::bar)

# ------------------------------------------------------------------------------
# calls to `super`

class MyClass
  def my_method
    super
    super()
    super 'blah'
    super 1, 2, 3
    super { |x| x + 1 }
    super do |x| x * 2 end
    super 4, 5 { |x| x + 100 }
    super 6, 7 do |x| x + 200 end
  end
end

# ------------------------------------------------------------------------------
# calls to methods simply named `super`, i.e. *not* calls to the same method in
# a parent classs, so these should be Call but not SuperCall

class AnotherClass
  def another_method
    foo.super
    self.super
    super.super # we expect the receiver to be a SuperCall, while the outer call should not (it's just a regular Call)
  end
end

# calls without method name
foo.()
foo.(1)

# setter calls
self.foo = 10
foo[0] = 10
self.foo, *self.bar, foo[4] = [1, 2, 3, 4]
a, *foo[5] = [1, 2, 3]
self.count += 1
foo[0] += 1
foo.bar[0, foo.baz, foo.boo + 1] *= 2

# endless method definitions
def foo = bar
def foo() = bar
def foo(x) = bar
def Object.foo = bar
def Object.foo (x) = bar
def foo() = bar rescue (print "error")

# forward parameter and forwarded arguments
def foo(...)
  super(...)
end

def foo(a, b, ...)
  bar(b, ...)
end

# for loop over nested array
for x, y, z in [[1,2,3], [4,5,6]]
  foo x, y, z
end

foo(x: 42)
foo(x:, novar:)
foo(X: 42)
foo(X:)

# calls inside lambdas
y = 1
one = ->(x) { y }
f = ->(x) { foo x }
g = ->(x) { unknown_call }
h = -> (x) do
  x
  y
  unknown_call
end

# calls with various call operators
list.empty?
list&.empty?
list::empty?
foo&.bar(1,2) { |x| x }