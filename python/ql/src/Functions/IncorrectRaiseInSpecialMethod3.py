    
#Incorrect file-backed table
class FileBackedTable(object):
    
    def __getitem__(self, key):
        if key not in self.index:
            raise IOError("Key '%s' not in table" % key)
        else:
            #May raise an IOError
            return self.backing.get_row(key)
        
#Correct by transforming exception
class ObjectLikeFileBackedTable(object):
    
    def get_from_key(self, key):
        if key not in self.index:
            raise IOError("Key '%s' not in table" % key)
        else:
            #May raise an IOError
            return self.backing.get_row(key)
    
    def __getitem__(self, key):
        try:
            return self.get_from_key(key)
        except IOError:
            raise KeyError(key)
                           
