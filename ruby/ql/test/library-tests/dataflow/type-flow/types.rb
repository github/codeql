def taint x
    x
end

def sink x
    puts "SINK: #{x.get_field}"
end

class C1
    @field

    def initialize(x)
        @field = x
    end

    def get_field
        @field
    end

    def call_foo
        foo(self)
    end

    def call_bar
        bar(self)
    end

    def maybe_sink
    end

    def call_maybe_sink
        maybe_sink
    end

    def call_call_maybe_sink
        call_maybe_sink
    end
end

class C2 < C1
    def maybe_sink
        sink self # $ hasValueFlow=13 $ hasValueFlow=self(C2) $ SPURIOUS: hasValueFlow=12
    end
end

class C3 < C1
    def maybe_sink
        sink self # $ hasValueFlow=14 $ hasValueFlow=self(C3) $ SPURIOUS: hasValueFlow=12
    end
end

def foo x
    case x
        when C3 then
            sink(x) # $ hasValueFlow=2 $ hasValueFlow=5 $ hasValueFlow=self(C1) $ SPURIOUS: hasValueFlow=0 $ SPURIOUS: hasValueFlow=3
            case x when C2 then sink(x) # dead code
        end
    end
end

def bar x
    case x
        in C3 => c3 then
            sink(c3) # $ hasValueFlow=8 $ hasValueFlow=11 $ hasValueFlow=self(C1) $ SPURIOUS: hasValueFlow=6 $ SPURIOUS: hasValueFlow=9
            case c3 when C2 then sink(c3) # dead code
        end
        else return
    end
end

foo(taint(C1.new 0))
foo(taint(C2.new 1))
foo(taint(C3.new 2))

taint(C1.new 3).call_foo
taint(C2.new 4).call_foo
taint(C3.new 5).call_foo

bar(taint(C1.new 6))
bar(taint(C2.new 7))
bar(taint(C3.new 8))

taint(C1.new 9).call_bar
taint(C2.new 10).call_bar
taint(C3.new 11).call_bar

taint(C1.new 12).call_call_maybe_sink
taint(C2.new 13).call_call_maybe_sink
taint(C3.new 14).call_call_maybe_sink
