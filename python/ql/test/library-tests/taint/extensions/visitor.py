

class Visitor(object):
    '''Visitor pattern '''

    def __init__(self, labels):
        self.labels = labels
        self.priority = 0

    def visit(self, node, arg):
        """Visit a node."""
        method = 'visit_' + node.__class__.__name__
        getattr(self, method, self.generic_visit)(node, arg)

    def generic_visit(self, node, arg):
        pass

    def visit_Class(self, node, arg):
        return arg

    def visit_Function(self, func, arg):
        pass

v = Visitor()

x = v.visit(dont_care, SOURCE)
x
