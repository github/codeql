class C1:
    def m1(self):
        print("C1.m1()")

    def m2(self, x):
        return x
    
    @staticmethod
    def m3(x):
        return x
    
    @classmethod
    def m4(cls, x):
        return x
    
class C2(C1):
    def m1(self):
        print("C2.m1()")

    def c2only_m1(self, x):
        return x

class C3:
    def get_C2_instance():
        return C2()