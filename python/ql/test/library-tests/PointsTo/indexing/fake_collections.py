# Use a fake collection module, otherwise we need to set the import depth to 3 
# which makes the test run very slowly.

class deque(object):
    
    def __getitem__(self, index):
        pass

    def append(self, item):
        pass
    
    def index(self, key):
        pass
    
    def __reversed__(self):
        pass
