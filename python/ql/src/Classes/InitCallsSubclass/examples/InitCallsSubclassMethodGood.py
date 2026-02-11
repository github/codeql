class Super(object):

    def __init__(self, arg):
        self._state = "Not OK"
        self.super_set_up(arg) # GOOD: This isn't overriden. Instead, additional setup the subclass needs is called by the subclass' `__init__ method.`
        self._state = "OK"

    def super_set_up(self, arg):
        "Do some setup"
        self.a = 2


class Sub(Super):

    def __init__(self, arg):
        super().__init__(arg)
        self.sub_set_up(self, arg)
        self.important_state = "OK"


    def sub_set_up(self, arg):
        "Do some more setup"
        if self._state == "OK":
            self.b = self.a + 2