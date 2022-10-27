def capture_local_call x
    fn = -> { sink(x) } # $ hasValueFlow=1.1
    fn.call
end
capture_local_call source(1.1)

def capture_escape_return1 x
    -> {
        sink(x) # $ MISSING: hasValueFlow=1.2
    }
end
(capture_escape_return1 source(1.2)).call

def capture_escape_return2 x
    -> {
        sink(x) # $ MISSING: hasValueFlow=1.3
    }
end
Something.unknownMethod(capture_escape_return2 source(1.3))

def capture_escape_unknown_call x
    fn = -> {
        sink(x) # $ hasValueFlow=1.4
    }
    Something.unknownMethod(fn)
end
capture_escape_unknown_call source(1.4)

def call_it fn
    fn.call
end
def capture_escape_known_call x
    fn = -> {
        sink(x) # $ hasValueFlow=1.5
    }
    call_it fn
end
capture_escape_known_call source(1.5)

def capture6
    captured = source(1.6)
    fn = -> {
        captured
    }
    fn.call
end
sink(capture6) # $ hasValueFlow=1.6

def capture7 x
    captured = x
    fn = -> {
        captured
    }
    fn.call
end
sink(capture7 'safe') # $ SPURIOUS: hasValueFlow=1.7
sink(capture7 source(1.7)) # $ hasValueFlow=1.7

def capture8 x
    captured = nil
    fn = -> {
        captured = x
    }
    fn.call
    captured
end
sink(capture8 'safe') # $ SPURIOUS: hasValueFlow=1.8
sink(capture8 source(1.8)) # $ hasValueFlow=1.8
