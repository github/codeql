
class BaseClass(object):

    def run(self, source, filename, symbol="single"):
        ... # Definition

    def load_and_run(self, filename):
        source = self.load(filename)
        self.run(source, filename) # Matches signature in this class, but not in the derived class.

class DerivedClass(BaseClass):

    def run(self, source):
        ... # Definition
