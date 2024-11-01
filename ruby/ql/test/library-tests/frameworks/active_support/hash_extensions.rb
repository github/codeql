def m_stringify_keys
    h = { a: source("a") }
    x = h.stringify_keys
    sink x["a"] # $hasValueFlow=a
end

m_stringify_keys()

def m_to_options
    h = { "a" => source("a") }
    x = h.to_options
    sink x[:a] # $hasValueFlow=a
end

m_to_options()

def m_symbolize_keys
    h = { "a" => source("a") }
    x = h.symbolize_keys
    sink x[:a] # $hasValueFlow=a
end

m_symbolize_keys()

def m_deep_stringify_keys
    h = { a: source("a") }
    x = h.deep_stringify_keys
    sink x["a"] # $hasValueFlow=a
end

m_deep_stringify_keys()

def m_deep_symbolize_keys
    h = { "a" => source("a") }
    x = h.deep_symbolize_keys
    sink x[:a] # $hasValueFlow=a
end

m_deep_symbolize_keys()

def m_with_indifferent_access
    h = { a: source("a") }
    x = h.with_indifferent_access
    sink x["a"] # $hasValueFlow=a
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

def m_index_with
    values = [source("a"), source("b"), source("c")]
    h = values.index_with do |key|
        sink key # $ hasValueFlow=a $ hasValueFlow=b $ hasValueFlow=c
        source("x")
    end

    sink h[:foo] # $ hasValueFlow=x
    sink h[:bar] # $ hasValueFlow=x

    j = values.index_with(source("y"))

    sink j[:foo] # $ hasValueFlow=y
    sink j[:bar] # $ hasValueFlow=y
end

m_index_with()

def m_pick
    values = [{ id: source("1"), name: source("David") }, { id: source("2"), name: source("Rafael") }]
    sink(values.pick(:id)) # $ hasValueFlow=1
    sink(values.pick(:name)) # $ hasValueFlow=David
    sink(values.pick(:id, :name)[0]) # $ hasValueFlow=1
    sink(values.pick(:id, :name)[1]) # $ hasValueFlow=David
    sink(values.pick(:name, :id)[0]) # $ hasValueFlow=David
    sink(values.pick(:name, :id)[1]) # $ hasValueFlow=1
end

m_pick()

def m_pluck(i)
    values = [{ id: source("1"), name: source("David") }, { id: source("2"), name: source("Rafael") }]
    sink(values.pluck(:name)[i]) # $ hasValueFlow=David $ hasValueFlow=Rafael
    sink(values.pluck(:id, :name)[i][0]) # $ hasValueFlow=1 $ hasValueFlow=2
    sink(values.pluck(:id, :name)[i][1]) # $ hasValueFlow=David $ hasValueFlow=Rafael
    sink(values.pluck(:name, :id)[i][0]) # $ hasValueFlow=David $ hasValueFlow=Rafael
    sink(values.pluck(:name, :id)[i][1]) # $ hasValueFlow=1 $ hasValueFlow=2
end

m_pluck(0)

def m_sole
    empty = []
    single = [source("a")]
    multi = [source("b"), source("c")]
    sink(empty.sole)
    sink(single.sole) # $ hasValueFlow=a
    sink(multi.sole) # TODO: model that 'sole' does not return if the receiver has multiple elements
end

m_sole()
