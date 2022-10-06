def m_deep_merge
    h1 = { a: source "a" }
    h2 = { b: source "b" }
    x = h1.deep_merge(h2)

    sink x[:a] # $ hasValueFlow=a
    sink x[:b] # $ hasValueFlow=b
end

def m_deep_merge!
    h1 = { a: source "a" }
    h2 = { b: source "b" }
    x = h1.deep_merge!(h2)

    sink x[:a] # $ hasValueFlow=a
    sink x[:b] # $ hasValueFlow=b

    sink h1[:a] # $ hasValueFlow=a
    sink h1[:b] # $ hasValueFlow=b

    sink h2[:a]
    sink h2[:b] # $ hasValueFlow=b
end

def m_stringify_keys
    h = { a: source "a" }
    x = h.stringify_keys
    sink x[:a] # $hasValueFlow=a
end

def m_to_options
    h = { a: taint "a" }
    x = h.to_options
    sink x[:a] # $hasTaintFlow=a
end

def m_symbolize_keys
    h = { a: taint "a" }
    x = h.symbolize_keys
    sink x[:a] # $hasTaintFlow=a
end

def m_deep_stringify_keys
    h = { a: taint "a" }
    x = h.deep_stringify_keys
    sink x[:a] # $hasTaintFlow=a
end

def m_deep_symbolize_keys
    h = { a: taint "a" }
    x = h.deep_symbolize_keys
    sink x[:a] # $hasTaintFlow=a
end

def m_with_indifferent_access
    h = { a: taint "a" }
    x = h.with_indifferent_access
    sink x[:a] # $hasTaintFlow=a
end

def m_extract!(x)
    h = { a: taint "a", b: taint "b", c: "c", d: taint "d" }
    x = h.extract!(:a, x, :b)

    sink h[:a]
    sink h[:b]
    sink h[:c]
    sink h[:d] # $ hasValueFlow=d

    sink x[:a] # $ hasValueFlow=a
    sink x[:b] # $ hasValueFlow=b
    sink x[:c]
    sink x[:d]
end

m_extract!(:c)
