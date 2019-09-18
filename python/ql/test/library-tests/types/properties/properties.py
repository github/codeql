class C(object):
    
    @property
    def p1(self):
        return 1
    
    @p1.setter
    def p1(self, val):
        pass
    
    @property
    def p2(self):
        return 1
    
    @p2.deleter
    def p2(self, val):
        pass
    
    def p3(self):
        return 1
    
    p3 = property(p3)
    
    def p3_set(self, val):
        pass
    
    p3 = p3.setter(p3_set)
    
    