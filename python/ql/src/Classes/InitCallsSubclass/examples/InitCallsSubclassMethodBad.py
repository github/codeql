class Super(object):

    def __init__(self, arg):
        self._state = "Not OK"
        self.set_up(arg) # BAD: This method is overridden, so `Sub.set_up` receives a partially initialized instance.
        self._state = "OK"

    def set_up(self, arg):
        "Do some setup"
        self.a = 2

class Sub(Super):

    def __init__(self, arg):
        super().__init__(arg)
        self.important_state = "OK"

    def set_up(self, arg):
        super().set_up(arg)
        "Do some more setup"
        # BAD: at this point `self._state` is set to `"Not OK"`, and `self.important_state` is not initialized.
        if self._state == "OK":
            self.b = self.a + 2
