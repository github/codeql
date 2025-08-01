class A:
    def __init__(self, a, b):
        self.a = a 
        self.b = b

    # No equality method is defined
    def __hash__(self):
        return hash((self.a, self.b))
