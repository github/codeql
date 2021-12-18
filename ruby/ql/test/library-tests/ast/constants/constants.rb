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
end

module ModuleA::ModuleC
end

ModuleA::ModuleB::MAX_SIZE = 1024

puts ModuleA::ModuleB::MAX_SIZE

puts GREETING
puts ::GREETING

module ModuleA::ModuleB
  class ClassB < Base
  end
end

module ModuleA
  class ModuleB::ClassB < Base
  end
end
