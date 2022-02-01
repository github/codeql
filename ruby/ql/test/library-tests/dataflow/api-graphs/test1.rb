MyModule #$ use=getMember("MyModule")
print MyModule.foo #$ use=getMember("MyModule").getReturn("foo")
Kernel.print(e) #$ use=getMember("Kernel").getReturn("print")
Object::Kernel #$ use=getMember("Kernel")
Object::Kernel.print(e)  #$ use=getMember("Kernel").getReturn("print")
begin
    print MyModule.bar #$ use=getMember("MyModule").getReturn("bar")
    raise AttributeError #$ use=getMember("AttributeError")
rescue AttributeError => e #$ use=getMember("AttributeError")
    Kernel.print(e)  #$ use=getMember("Kernel").getReturn("print")
end
Unknown.new.run #$ use=getMember("Unknown").getReturn("new").getReturn("run")
Foo::Bar::Baz #$ use=getMember("Foo").getMember("Bar").getMember("Baz")

Const = [1, 2, 3] #$ use=getMember("Array").getReturn("[]")
Const.each do |c| #$ use=getMember("Const").getReturn("each")
    puts c #$ use=getMember("Const").getReturn("each").getBlock().getParameter(0)
end

foo = Foo #$ use=getMember("Foo")
foo::Bar::Baz #$ use=getMember("Foo").getMember("Bar").getMember("Baz")

FooAlias = Foo #$ use=getMember("Foo")
FooAlias::Bar::Baz #$ use=getMember("Foo").getMember("Bar").getMember("Baz")

module Outer
    module Inner
    end
end

Outer::Inner.foo #$ use=getMember("Outer").getMember("Inner").getReturn("foo")

module M1
    class C1
        def self.m
        end

        def m
        end
    end
end

class C2 < M1::C1 #$ use=getMember("M1").getMember("C1")
end

module M2
    class C3 < M1::C1 #$ use=getMember("M1").getMember("C1")
    end
    
    class C4 < C2 #$ use=getMember("C2")
    end
end

C2 #$ use=getMember("C2") use=getMember("M1").getMember("C1").getASubclass()
M2::C3 #$ use=getMember("M2").getMember("C3") use=getMember("M1").getMember("C1").getASubclass()
M2::C4 #$ use=getMember("M2").getMember("C4") use=getMember("C2").getASubclass() use=getMember("M1").getMember("C1").getASubclass().getASubclass()

M1::C1.m #$ use=getMember("M1").getMember("C1").getReturn("m")
M2::C3.m #$ use=getMember("M2").getMember("C3").getReturn("m") use=getMember("M1").getMember("C1").getASubclass().getReturn("m")

M1::C1.new.m #$ use=getMember("M1").getMember("C1").getReturn("new").getReturn("m")
M2::C3.new.m #$ use=getMember("M2").getMember("C3").getReturn("new").getReturn("m")
