#Unguarded calls to next()

def bad1(it):
    while True:
        yield next(it)

def bad2(seq):
    it = iter(seq)
    #Not OK as seq  may be empty
    raise KeyError(next(it))
    yield 0

def ok1(seq):
    #Not a generator
    it = iter(seq)
    #Not OK as seq  may be empty
    raise KeyError(next(it))

def ok2(seq):
    if seq:
        it = iter(seq)
        #OK seq is non-empty so next(it) will not raise StopIteration
        raise KeyError(next(it))
    yield 0

def explicit_raise_stop_iter(seq):
    for i in seq:
        yield seq
    raise StopIteration()

def ok3(seq):
    it = iter(seq)
    try:
        yield next(iter)
    except StopIteration:
        return

def ok4(seq, ctx):
    try:
        with ctx:
            yield next(iter)
    except StopIteration:
        return

#ODASA-6536
def next_in_comp(seq, fields):
    seq_iter = iter(seq)
    values = [ next(seq_iter) if f.attname in NAMES else DEFAULT for f in fields ]
    return values

def ok5(seq):
    yield next(iter([]), 'foo')

def ok6(seq):
    yield next(iter([]), default='foo')    

# Handling for multiple exception types, one of which is `StopIteration`
# Reported as a false positive in github/codeql#6227
def ok7(seq, ctx):
    try:
        with ctx:
            yield next(iter)
    except (StopIteration, MemoryError):
        return
