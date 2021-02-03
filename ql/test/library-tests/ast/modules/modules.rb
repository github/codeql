module Empty
end

module Foo
  module Bar
    class ClassInFooBar
    end

    def method_in_foo_bar
    end

    puts 'module Foo::Bar'
    $global_var = 0
  end

  def method_in_foo
  end

  class ClassInFoo
  end

  puts 'module Foo'
  $global_var = 1
end

module Foo
  def method_in_another_definition_of_foo
  end

  class ClassInAnotherDefinitionOfFoo
  end

  puts 'module Foo again'
  $global_var = 2
end

module Bar
  def method_a
  end

  def method_b
  end

  puts 'module Bar'
  $global_var = 3
end

module Foo::Bar
  class ClassInAnotherDefinitionOfFooBar
  end

  def method_in_another_definition_of_foo_bar
  end

  puts 'module Foo::Bar again'
  $global_var = 4
end