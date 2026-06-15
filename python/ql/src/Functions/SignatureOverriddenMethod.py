
class Base:
    def runsource(self, source, filename="<input>"):
        ...
    
    
class Sub(Base):
    def runsource(self, source): # BAD: Does not match the signature of overridden method.
        ... 

def run(obj: Base):
    obj.runsource("source", filename="foo.txt")