def taint x
    x
end

def sink x
    puts "SINK: #{x}"
end

def apply (f, x)
    f.call(x)
end

def apply_wrap (f, x)
    apply(f, x)
end

apply_wrap(->(x) { sink(x) }, taint(1)) # $ hasValueFlow=1
apply_wrap(->(x) { sink(x) }, "safe")

def apply_block x
    yield x
end

def apply_block_wrap (x, &block)
    apply_block(x, &block)
end

apply_block_wrap(taint(2)) { |x| sink(x) } # $ hasValueFlow=2
apply_block_wrap("safe") { |x| sink(x) }