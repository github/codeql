
class InheritsFromObject:

    def __init__(self, args):
        self.a, self.b = args

class RedefineEquals:

    def __eq__(self, other):
        return other is "Tuesday"

class C(RedefineEquals):

    def __init__(self, args):
        self.a, self.b = args
