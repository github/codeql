
def lookup_with_default_key(mapping, key=None):
    if key is None:
        key = [] # Should be key = ()
    return mapping[key]
