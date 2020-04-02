from invoke import Context

@decorator
def opens(method, self, *args, **kwargs):
    self.open()
    return method(self, *args, **kwargs)

class Connection(Context):

    def open(self):
        pass

    @opens
    def run(self, command, **kwargs):
        pass
