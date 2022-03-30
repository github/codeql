
# a class with no superclass specified
class Foo
end

# a class where the superclass is a constant
class Bar < BaseClass
end

# a class where the superclass is a call expression
class Baz < superclass_for(:baz)
end

# a class where the name is a scope resolution
module MyModule; end
class MyModule::MyClass
end

# a class with various expressions
class Wibble
  def method_a
    puts 'a'
  end

  def method_b
    puts 'b'
  end

  some_method_call()
  $global_var = 123

  class ClassInWibble
  end

  module ModuleInWibble
  end
end

# a singleton class with some methods and some other arbitrary expressions
x = 'hello'
class << x
  def length
    100 * super
  end

  def wibble
    puts 'wibble'
  end

  another_method_call
  $global_var2 = 456
end

# a class where the name is a scope resolution using the global scope
class ::MyClassInGlobalScope
end