
def filter1(function, iterable=None)
    if iterable == None:    # Comparison using '__eq__'
        return [item for item in iterable if item]
    else:
        return [item for item in iterable if function(item)]

def filter2(function, iterable=None)
    if iterable is None:    # Comparison using identity
        return [item for item in iterable if item]
    else:
        return [item for item in iterable if function(item)]
