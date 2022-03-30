module ModuleA
    class ClassA
        CONST_A = "const_a"
    end

    CONST_B = "const_b"

    module ModuleB
        class ClassB < Base
        end

        class ClassC < X::Y::Z
        end
    end
end

GREETING = 'Hello' + ModuleA::ClassA::CONST_A + ModuleA::CONST_B

def foo
    Names = ['Vera', 'Chuck', 'Dave']

    Names.each do |name|
        puts "#{ GREETING } #{ name }"
    end

    # A call to Kernel::Array; despite beginning with an upper-case character,
    # we don't consider this to be a constant access.
    Array('foo')
end

class ModuleA::ClassD < ModuleA::ClassA
  FOURTY_TWO = 42
end

module ModuleA::ModuleC
  FOURTY_THREE = 43
end

ModuleA::ModuleB::MAX_SIZE = 1024

puts ModuleA::ModuleB::MAX_SIZE

puts GREETING
puts ::GREETING

module ModuleA::ModuleB
  class ClassB < Base
    FOURTY_ONE = 41
  end
end

module ModuleA
  FOURTY_FOUR = "fourty-four"
  class ModuleB::ClassB < Base
    @@fourty_four = FOURTY_FOUR # refers to ::ModuleA::FOURTY_FOUR
    FOURTY_FOUR = 44
    @@fourty_four = FOURTY_FOUR # refers to ::ModuleA::ModuleB::ClassB::FOURTY_FOUR
  end
end

module Mod1
  module Mod3
    FOURTY_FIVE = 45
  end
  @@fourty_five = Mod3::FOURTY_FIVE
end

module Mod4
  include Mod1
  module Mod3::Mod5
    FOURTY_SIX = 46
  end
  @@fourty_six = Mod3::FOURTY_SIX
end
