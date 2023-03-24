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
