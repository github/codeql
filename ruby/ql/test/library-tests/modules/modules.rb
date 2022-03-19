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

# a module where the name is a scope resolution using the global scope
module ::MyModuleInGlobalScope
end

module Test

  module Foo1
    class Foo1::Bar
    end
  end

  module Foo2
    module Foo2 end
    class Foo2::Bar
    end
  end
  
  module Foo3
    Foo3 = Object
    class Foo3::Bar
    end
  end
end

module Other
  module Foo1
  end
end

module IncludeTest
  include ::Test
  Object.module_eval { prepend Other }
  module Foo1::Y
  end
end

module IncludeTest2
  include Test
  module Foo1::Z
  end
end

module PrependTest
  prepend ::Test
  module Foo2::Y
  end
end

module MM
  module MM::MM
  end
end

class YY
end

module XX
      class YY < YY
      end
end

module Test::Foo1::Bar::Baz
end
