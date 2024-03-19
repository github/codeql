
from abc import abstractmethod

class Pass(object):
    '''The base class for all extractor passes.
    Defines a single method 'extract' for all extractors to override'''

    @abstractmethod
    def extract(self, module, writer):
        '''Extract trap file data from 'module', writing it to the writer.'''
        pass
