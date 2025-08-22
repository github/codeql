def taint x
    x
end

def sink x
    puts "SINK: #{x}"
end

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
    @foo = taint("7")
    sink(@foo) # $ hasValueFlow=7

    def initialize(field = nil)
        @field = field
        taint(31)
    end

    def call_initialize(field)
        initialize(field)
    end

    def self.bar x
        new(taint(36))
        new(x)
    end

    sink(new(taint(34)).get_field) # $ hasValueFlow=34
end

sink(Foo.bar(taint(35)).get_field) # $ hasValueFlow=35

class Bar < Foo
    def self.new arg
        taint(32)
    end
end

class Baz < Foo
    def initialize x
        sink x # $ hasValueFlow=36
    end
end

foo = Foo.new
foo.set_field(taint(42))
sink(foo.get_field) # $ hasValueFlow=42

bar = Foo.new
bar.set_field(taint(5))
sink(bar.inc_field) # $ hasTaintFlow=5

foo1 = Foo.new
foo1.field = taint(20)
sink(foo1.field) # $ hasValueFlow=20

foo2 = Foo.new
foo2.field = taint(21)
sink(foo2.get_field) # $ hasValueFlow=21

foo3 = Foo.new
foo3.set_field(taint(22))
sink(foo3.field) # $ hasValueFlow=22

foo4 = 4
foo4.other = taint(23)
sink(foo4.other) # no field flow for constants

foo5 = Foo.new
(foo5).set_field(taint(24))
sink(foo5.get_field) # $ hasValueFlow=24

foo6 = Foo.new
(foo3; (foo5; foo6)).set_field(taint(25))
sink(foo3.get_field) # $ hasValueFlow=22
sink(foo5.get_field) # $ hasValueFlow=24
sink(foo6.get_field) # $ hasValueFlow=25

foo7 = Foo.new
foo8 = Foo.new
(if foo7 then foo7 else foo8 end).set_field(taint(26))
sink(foo7.get_field) # $ hasValueFlow=26
sink(foo8.get_field) # $ hasValueFlow=26

foo9 = Foo.new
foo10 = Foo.new
(case when foo9 then foo9 else foo10 end).set_field(taint(27))
sink(foo9.get_field) # $ hasValueFlow=27
sink(foo10.get_field) # $ hasValueFlow=27

def set_field_on x
    x.set_field(taint(28))
end

foo11 = Foo.new
set_field_on(foo11)
sink(foo11.get_field) # $ hasValueFlow=28

foo12 = Foo.new
set_field_on (foo12) # space after `set_field_on` is important for this test
sink(foo12.get_field) # $ hasValueFlow=28

foo13 = Foo.new
foo14 = Foo.new
set_field_on(foo14 = foo13)
sink(foo13.get_field) # $ hasValueFlow=28

foo15 = Foo.new(taint(29))
sink(foo15.get_field) # $ hasValueFlow=29
foo16 = Foo.new
sink(foo16.call_initialize(taint(30))) # $ hasValueFlow=31
sink(foo16.get_field) # $ hasValueFlow=30
bar = Bar.new(taint(33))
sink(bar) # $ hasValueFlow=32
sink(bar.get_field)