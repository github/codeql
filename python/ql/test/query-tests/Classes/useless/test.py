
#Useless class

class Useful1(object):

    def __init__(self):
        pass

    def do_something(self):
        pass

    def do_something_else(self):
        pass

    def do_yet_another_thing(self):
        pass


class Useful2(object):

    def do_something(self):
        pass

    def do_something_else(self):
        pass


class Useless1(object):

    def __init__(self):
        pass

    def do_something(self):
        pass


class Useless2(object):

    def do_something(self):
        pass
    
class Stateful1(object):

    def __init__(self):
        self.data = []

    def do_something(self, x):
        self.data.append(x)

    
class Stateful2(object):

    def __init__(self):
        self.data = None

    def do_something(self, x):
        self.data = x
        
class Inherited(object):
    pass

class Inherits(Inherited):
    
    def do_something(self):
        pass
