

#Check that MRO follows C3.


class T1(object): pass

class T2(object): pass

class T3(T2): pass

class Test(T3, T1): pass

#>>> Test.mro()
# [Test, T3, T2, T1, object]
