def taint x
    x
end

def sink x
    puts "SINK: #{x}"
end

x = taint(1)
[1, 2, 3].each do |i|
    sink x # $ hasValueFlow=1 $ MISSING: hasValueFlow=2
    x = taint(2)
end

sink x # $ hasValueFlow=2

class Foo
    def set_field x
        @field = x
    end
    def get_field
        return @field
    end
end

foo = Foo.new
foo.set_field(taint(3))
[1, 2, 3].each do |i|
    sink(foo.get_field) # $ hasValueFlow=3 $ MISSING: hasValueFlow=4
    foo.set_field(taint(4))
end

sink(foo.get_field) # $ hasValueFlow=4 $ SPURIOUS: hasValueFlow=3 

foo = Foo.new
if (rand() < 0) then
    foo = Foo.new
else
    [1, 2, 3].each do |i|
        foo.set_field(taint(5))
    end
end

sink(foo.get_field) # $ hasValueFlow=5
