MyModule #$ use=moduleImport("MyModule")
print MyModule.foo #$ use=moduleImport("MyModule").getReturn("foo")
Kernel.print(e) #$ use=moduleImport("Kernel").getReturn("print")
Object::Kernel #$ use=moduleImport("Kernel")
Object::Kernel.print(e)  #$ use=moduleImport("Kernel").getReturn("print")
begin
    print MyModule.bar #$ use=moduleImport("MyModule").getReturn("bar")
    raise AttributeError #$ use=moduleImport("AttributeError")
rescue AttributeError => e #$ use=moduleImport("AttributeError")
    Kernel.print(e)  #$ use=moduleImport("Kernel").getReturn("print")
end
Unknown.new.run #$ use=moduleImport("Unknown").instance.getReturn("run")
Foo::Bar::Baz #$ use=moduleImport("Foo").getMember("Bar").getMember("Baz")