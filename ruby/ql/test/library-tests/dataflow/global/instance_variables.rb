class Foo
    def set_field x
        @field = x
    end
    def get_field
        return @field
    end
    def inc_field
        @field += 1
    end
    @foo = source("7")
    sink(@foo) # $ hasValueFlow=7

end
foo = Foo.new
foo.set_field(source(42))
sink(foo.get_field) # $ hasValueFlow=42

bar = Foo.new
bar.set_field(source(5))
sink(bar.inc_field) # $ hasTaintFlow=5

foo1 = Foo.new
foo1.field = source(20)
sink(foo1.field) # $ hasValueFlow=20

foo2 = Foo.new
foo2.field = source(21)
sink(foo2.get_field) # $ hasValueFlow=21

foo3 = Foo.new
foo3.set_field(source(22))
sink(foo3.field) # $ hasValueFlow=22

foo4 = "hello"
foo4.other = source(23)
sink(foo4.other) # $ hasValueFlow=23
