MyModule #$ source=Member[MyModule]
print MyModule.foo #$ source=Member[MyModule].Method[foo].ReturnValue
Kernel.print(e) #$ source=Member[Kernel].Method[print].ReturnValue sink=Member[Kernel].Method[print].Argument[0]
Object::Kernel #$ source=Member[Kernel]
Object::Kernel.print(e)  #$ source=Member[Kernel].Method[print].ReturnValue
begin
    print MyModule.bar #$ source=Member[MyModule].Method[bar].ReturnValue
    raise AttributeError #$ source=Member[AttributeError]
rescue AttributeError => e #$ source=Member[AttributeError]
    Kernel.print(e)  #$ source=Member[Kernel].Method[print].ReturnValue
end
Unknown.new.run #$ source=Member[Unknown].Method[new].ReturnValue.Method[run].ReturnValue
Foo::Bar::Baz #$ source=Member[Foo].Member[Bar].Member[Baz]

Const = [1, 2, 3] #$ source=Member[Array].MethodBracket.ReturnValue
Const.each do |c| #$ source=Member[Const]
    puts c #$ reachableFromSource=Member[Const].Method[each].Argument[block].Parameter[0] reachableFromSource=Member[Const].Element[any]
end #$ source=Member[Const].Method[each].ReturnValue sink=Member[Const].Method[each].Argument[block]

foo = Foo #$ source=Member[Foo]
foo::Bar::Baz #$ source=Member[Foo].Member[Bar].Member[Baz]

FooAlias = Foo #$ source=Member[Foo]
FooAlias::Bar::Baz #$ source=Member[Foo].Member[Bar].Member[Baz] source=Member[FooAlias].Member[Bar].Member[Baz]

module Outer
    module Inner
    end
end

Outer::Inner.foo #$ source=Member[Outer].Member[Inner].Method[foo].ReturnValue

module M1
    class C1
        def self.m
        end

        def m
        end
    end
end

class C2 < M1::C1 #$ source=Member[M1].Member[C1]
end

module M2
    class C3 < M1::C1 #$ source=Member[M1].Member[C1]
    end

    class C4 < C2 #$ source=Member[C2]
    end
end

C2 #$ source=Member[C2] reachableFromSource=Member[M1].Member[C1]
M2::C3 #$ source=Member[M2].Member[C3] reachableFromSource=Member[M1].Member[C1]
M2::C4 #$ source=Member[M2].Member[C4] reachableFromSource=Member[C2] reachableFromSource=Member[M1].Member[C1]

M1::C1.m #$ source=Member[M1].Member[C1].Method[m].ReturnValue
M2::C3.m #$ source=Member[M2].Member[C3].Method[m].ReturnValue source=Member[M1].Member[C1].Method[m].ReturnValue

M1::C1.new.m #$ source=Member[M1].Member[C1].Method[new].ReturnValue.Method[m].ReturnValue
M2::C3.new.m #$ source=Member[M2].Member[C3].Method[new].ReturnValue.Method[m].ReturnValue

Foo.foo(a,b:c) #$ source=Member[Foo].Method[foo].ReturnValue sink=Member[Foo].Method[foo].Argument[0] sink=Member[Foo].Method[foo].Argument[b:]

def userDefinedFunction(x, y)
    x.noApiGraph(y)
    x.customEntryPointCall(y) #$ call=EntryPoint[CustomEntryPointCall] source=EntryPoint[CustomEntryPointCall].ReturnValue sink=EntryPoint[CustomEntryPointCall].Parameter[0]
    x.customEntryPointUse(y) #$ source=EntryPoint[CustomEntryPointUse]
end

array = [A::B::C] #$ source=Member[Array].MethodBracket.ReturnValue
array[0].m #$ source=Member[A].Member[B].Member[C].Method[m].ReturnValue source=Member[Array].MethodBracket.ReturnValue.Element[0].Method[m].ReturnValue

A::B::C[0] #$ source=Member[A].Member[B].Member[C].Element[0]
