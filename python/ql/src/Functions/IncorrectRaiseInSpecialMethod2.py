    
#Abstract base class, but don't declare it.
class ImplicitAbstractClass(object):
    
    def __add__(self, other):
        raise NotImplementedError()
    
#Make abstractness explicit.
class ExplicitAbstractClass:
    __metaclass__ = ABCMeta

    @abstractmethod
    def __add__(self, other):
        raise NotImplementedError()
 
