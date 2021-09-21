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
Unknown.new.run #$ use=getMember("Unknown").instance.getReturn("run")
Foo::Bar::Baz #$ use=getMember("Foo").getMember("Bar").getMember("Baz")

Const = [1, 2, 3] #$ use=getMember("Array").getReturn("[]")
Const.each do |c| #$ use=getMember("Const").getReturn("each")
    puts c
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
