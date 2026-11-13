
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


class Useless1(object): # $ Alert

    def __init__(self):
        pass

    def do_something(self):
        pass


class Useless2(object): # $ Alert

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

class StatefulAugmentedAttribute(object):

    def update(self):
        self.value += 1

class StatefulAugmentedSubscript(object):

    def update(self):
        self.values[0] += 1
        
class Inherited(object):
    pass

class Inherits(Inherited):
    
    def do_something(self):
        pass
