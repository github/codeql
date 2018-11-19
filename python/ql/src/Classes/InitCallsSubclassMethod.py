#Superclass __init__ calls subclass method

class Super(object):

    def __init__(self, arg):
        self._state = "Not OK"
        self.set_up(arg)
        self._state = "OK"

    def set_up(self, arg):
        "Do some set up"

class Sub(Super):

    def __init__(self, arg):
        Super.__init__(self, arg)
        self.important_state = "OK"

    def set_up(self, arg):
        Super.set_up(self, arg)
        "Do some more set up" # Dangerous as self._state is "Not OK"


#Improved version with inheritance:

class Super(object):

    def __init__(self, arg):
        self._state = "Not OK"
        self.super_set_up(arg)
        self._state = "OK"

    def super_set_up(self, arg):
        "Do some set up"


class Sub(Super):

    def __init__(self, arg):
        Super.__init__(self, arg)
        self.sub_set_up(self, arg)
        self.important_state = "OK"


    def sub_set_up(self, arg):
        "Do some more set up"


