module ModuleA
    class ClassA
    end

    module ModuleB
        class ClassB < Base
        end

        class ClassC < X::Y::Z
        end
    end
end

GREETING = 'Hello'

def foo
    Names = ['Vera', 'Chuck', 'Dave']

    Names.each do |name|
        puts "#{ GREETING } #{ name }"
    end

    # A call to Kernel::Array; despite beginning with an upper-case character,
    # we don't consider this to be a constant access.
    Array('foo')
end

class ModuleA::ClassD
end

module ModuleA::ModuleC
end

ModuleA::ModuleB::MAX_SIZE = 1024