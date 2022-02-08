# Tests for the different kinds and contexts of parameters.

# Method containing identifier parameters
def identifier_method_params(foo, bar, baz)
end

# Block containing identifier parameters
hash = {}
hash.each do |key, value|
  puts "#{key} -> #{value}"
end

# Lambda containing identifier parameters
sum = -> (foo, bar) { foo + bar }

# Method containing destructured parameters
def destructured_method_param((a, b, c))
end

# Block containing destructured parameters
array = []
array.each { |(a, b)| puts a+b }

# Lambda containing destructured parameters
sum_four_values = -> ((first, second), (third, fourth)) {
  first + second + third + fourth
}

# Method containing splat and hash-splat params
def method_with_splat(wibble, *splat, **double_splat)
end

# Block with splat and hash-splat parameter
array.each do |val, *splat, **double_splat|
end

# Lambda with splat and hash-splat
lambda_with_splats = -> (x, *blah, **wibble) {}

# Method containing keyword parameters
def method_with_keyword_params(x, foo:, bar: 7)
  x + foo + bar
end

# Block with keyword parameters
def use_block_with_keyword(&block)
  puts(block.call bar: 2, foo: 3)
end
use_block_with_keyword do |xx:, yy: 100|
  xx + yy
end

lambda_with_keyword_params = -> (x, y:, z: 3) {
  x + y + z
}

# Method containing optional parameters
def method_with_optional_params(val1, val2 = 0, val3 = 100)
end

# Block containing optional parameter
def use_block_with_optional(&block)
  block.call 'Zeus'
end
use_block_with_optional do |name, age = 99|
  puts "#{name} is #{age} years old"
end

# Lambda containing optional parameters
lambda_with_optional_params = -> (a, b = 1000, c = 20) { a+b+c }

# Method containing nil hash-splat params
def method_with_nil_splat(wibble, **nil)
end

# Block with nil hash-splat parameter
array.each do |val, **nil|
end

# Anonymous block parameter
def anonymous_block_parameter(array, &)
  proc(&)
  array.each(&)
end
