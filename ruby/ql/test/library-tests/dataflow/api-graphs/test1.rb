MyModule #$ use=getMember("MyModule")
print MyModule.foo #$ use=getMember("MyModule").getMethod("foo").getReturn()
Kernel.print(e) #$ use=getMember("Kernel").getMethod("print").getReturn() def=getMember("Kernel").getMethod("print").getParameter(0)
Object::Kernel #$ use=getMember("Kernel")
Object::Kernel.print(e)  #$ use=getMember("Kernel").getMethod("print").getReturn()
begin
    print MyModule.bar #$ use=getMember("MyModule").getMethod("bar").getReturn()
    raise AttributeError #$ use=getMember("AttributeError")
rescue AttributeError => e #$ use=getMember("AttributeError")
    Kernel.print(e)  #$ use=getMember("Kernel").getMethod("print").getReturn()
end
Unknown.new.run #$ use=getMember("Unknown").getMethod("new").getReturn().getMethod("run").getReturn()
Foo::Bar::Baz #$ use=getMember("Foo").getMember("Bar").getMember("Baz")

Const = [1, 2, 3] #$ use=getMember("Array").getMethod("[]").getReturn()
Const.each do |c| #$ use=getMember("Const").getMethod("each").getReturn() def=getMember("Const").getMethod("each").getBlock()
    puts c #$ use=getMember("Const").getMethod("each").getBlock().getParameter(0)
end

foo = Foo #$ use=getMember("Foo")
foo::Bar::Baz #$ use=getMember("Foo").getMember("Bar").getMember("Baz")

FooAlias = Foo #$ use=getMember("Foo")
FooAlias::Bar::Baz #$ use=getMember("Foo").getMember("Bar").getMember("Baz")

module Outer
    module Inner
    end
end

Outer::Inner.foo #$ use=getMember("Outer").getMember("Inner").getMethod("foo").getReturn()

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

M1::C1.m #$ use=getMember("M1").getMember("C1").getMethod("m").getReturn()
M2::C3.m #$ use=getMember("M2").getMember("C3").getMethod("m").getReturn() use=getMember("M1").getMember("C1").getASubclass().getMethod("m").getReturn()

M1::C1.new.m #$ use=getMember("M1").getMember("C1").getMethod("new").getReturn().getMethod("m").getReturn()
M2::C3.new.m #$ use=getMember("M2").getMember("C3").getMethod("new").getReturn().getMethod("m").getReturn()

Foo.foo(a,b:c) #$ use=getMember("Foo").getMethod("foo").getReturn() def=getMember("Foo").getMethod("foo").getParameter(0) def=getMember("Foo").getMethod("foo").getKeywordParameter("b")

def userDefinedFunction(x, y)
    x.noApiGraph(y)
    x.customEntryPointCall(y) #$ call=CustomEntryPointCall use=CustomEntryPointCall.getReturn() rhs=CustomEntryPointCall.getParameter(0)
    x.customEntryPointUse(y) #$ use=CustomEntryPointUse
end
