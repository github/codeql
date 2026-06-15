
def outer():
    from foo import bar, baz
    
    def inner_bar():
        f = bar
        g = baz
        return f()
    
    def inner_baz():
        f = bar
        g = baz
        return g()