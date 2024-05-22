class C1:
    def m1(self):
        print("C1.m1()")

    def m2(self, x):
        return x
    
class C2(C1):
    def m1(self):
        print("C2.m1()")

    def m2(self, x):
        return x