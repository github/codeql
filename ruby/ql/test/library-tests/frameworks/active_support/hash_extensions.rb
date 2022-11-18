def m_stringify_keys
    h = { a: source("a") }
    x = h.stringify_keys
    sink x[:a] # $hasValueFlow=a
end

m_stringify_keys()

def m_to_options
    h = { a: source("a") }
    x = h.to_options
    sink x[:a] # $hasValueFlow=a
end

m_to_options()

def m_symbolize_keys
    h = { a: source("a") }
    x = h.symbolize_keys
    sink x[:a] # $hasValueFlow=a
end

m_symbolize_keys()

def m_deep_stringify_keys
    h = { a: source("a") }
    x = h.deep_stringify_keys
    sink x[:a] # $hasValueFlow=a
end

m_deep_stringify_keys()

def m_deep_symbolize_keys
    h = { a: source("a") }
    x = h.deep_symbolize_keys
    sink x[:a] # $hasValueFlow=a
end

m_deep_symbolize_keys()

def m_with_indifferent_access
    h = { a: source("a") }
    x = h.with_indifferent_access
    sink x[:a] # $hasValueFlow=a
end

m_with_indifferent_access()

def m_extract!(x)
    h = { a: taint("a"), b: taint("b"), c: "c", d: taint("d") }
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

def m_index_by
    values = [source("a"), source("b"), source("c")]
    h = values.index_by do |value|
        sink value # $ hasValueFlow=a $ hasValueFlow=b $ hasValueFlow=c
        make_key(value)
    end

    sink h[:foo] # $ hasValueFlow=a $ hasValueFlow=b $ hasValueFlow=c
    sink h[:bar] # $ hasValueFlow=a $ hasValueFlow=b $ hasValueFlow=c
end

m_index_by()
