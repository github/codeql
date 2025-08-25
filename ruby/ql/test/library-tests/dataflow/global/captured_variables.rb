def taint x
    x
end

def sink x
    puts "SINK: #{x}"
end

def capture_local_call x
    fn = -> { sink(x) } # $ hasValueFlow=1.1
    fn.call
end
capture_local_call taint(1.1)

def capture_escape_return1 x
    -> {
        sink(x) # $ hasValueFlow=1.2
    }
end
(capture_escape_return1 taint(1.2)).call

def capture_escape_return2 x
    -> {
        sink(x) # $ hasValueFlow=1.3
    }
end
Something.unknownMethod(capture_escape_return2 taint(1.3))

def capture_escape_unknown_call x
    fn = -> {
        sink(x) # $ hasValueFlow=1.4
    }
    Something.unknownMethod(fn)
end
capture_escape_unknown_call taint(1.4)

def call_it fn
    fn.call
end
def capture_escape_known_call x
    fn = -> {
        sink(x) # $ hasValueFlow=1.5
    }
    call_it fn
end
capture_escape_known_call taint(1.5)

x = taint(1)
[1, 2, 3].each do |i|
    sink x # $ hasValueFlow=1 $ MISSING: hasValueFlow=2
    x = taint(2)
end

sink x # $ hasValueFlow=2 $ SPURIOUS: hasValueFlow=1

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

y = taint(6)
fn = -> {
    sink(y) # $ hasValueFlow=6
    y = taint(7)
}
fn.call
sink(y) # $ hasValueFlow=7 $ SPURIOUS: hasValueFlow=6

def capture_arg x
    -> {
        sink x # $ hasValueFlow=8
    }
end
capture_arg(taint(8)).call

def call_block_with x
    yield x
end

call_block_with(taint(9)) do |x|
    sink x # $ hasValueFlow=9
end

def capture_nested
    x = taint(10)
    middle = -> {
        inner = -> {
            sink x # $ hasValueFlow=10
            x = taint(11)
        }
        inner.call
    }
    middle.call
    sink x # $ hasValueFlow=11 $ SPURIOUS: hasValueFlow=10
end
capture_nested

def lambdas
    x = 123

    fn1 = -> {
        sink x # $ MISSING: hasValueFlow=12
    }

    fn3 = -> {
        y = taint(12)

        fn2 = -> {
            x = y
        }

        fn2
    }

    fn4 = fn3.call()
    fn4.call()
    fn1.call()
end

lambdas

module CaptureModuleSelf
    @x = taint(13)

    def self.foo
        yield
    end

    self.foo do
        sink @x # $ hasValueFlow=13
    end
end

class CaptureInstanceSelf1
    def initialize
        @x = taint(14)
    end

    def bar
        yield
    end

    def baz
        self.bar do
            sink @x # $ hasValueFlow=14
        end
    end
end

CaptureInstanceSelf1.new.baz

class CaptureInstanceSelf2
    def foo
        @x = taint(15)
    end

    def bar
        yield
    end

    def baz
        self.bar do
            sink @x # $ hasValueFlow=15
        end
    end
end

c = CaptureInstanceSelf2.new
c.foo
c.baz

class CaptureOverwrite
    x = taint(16)

    sink(x) # $ hasValueFlow=16

    x = nil

    sink(x)

    fn = -> {
        x = taint(17)

        sink(x) # $ hasValueFlow=17

        x = nil

        sink(x)
    }

    fn.call()
end

def multi_capture
    x = taint(18)
    y = 123

    fn1 = -> {
        y = x
    }

    fn1.call()
    sink(y) # $ hasValueFlow=18
end

multi_capture

def m1
    x = taint(19)
    
    fn1 = -> {
        sink x
    }

    x = nil

    fn1.call()
end

m1