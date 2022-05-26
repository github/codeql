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