
class BaseClass(object):

    def run(self, source, filename, symbol="single"):
        ... # Definition

    def load_and_run(self, filename):
        source = self.load(filename)
        self.run(source) # Matches signature in derived class, but not in this class.

class DerivedClass(BaseClass):

    def run(self, source):
        ... # Definition
