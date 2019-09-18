#Modules should have docstrings

class OK:
    'Classes need doc strings'

    'Two strings'
    pass
    "Another string"
#All functions must be multi-line or there are ignored by the query


class _OK:
    'Unless they are private'
    pass
    pass

def f_ok(x, y):
    'And functions'
    pass
    pass

def _f_ok(y, z):
    #Unless they are private
    pass
    pass

class OK2:
    'doc-string'

    def meth_ok(self):
        'Methods need docstrings'
        pass
        pass

    def _meth_ok(self):
        #Unless they are private
        pass
        pass

class Not_OK:
    #No docstring

    def meth_ok(self):
        'Methods need docstrings'
        pass
        pass

    def meth_not_ok(self):
        #No doc-string
        pass
        pass

def not_ok(x, y):
    #Should have a doc-string
    pass
    pass



