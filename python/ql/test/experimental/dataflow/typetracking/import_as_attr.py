from module import attr as attr_ref

x = attr_ref

def fun():
    y = attr_ref

# The following should _not_ be a reference to the above module, since we don't actually import it.
z = module
