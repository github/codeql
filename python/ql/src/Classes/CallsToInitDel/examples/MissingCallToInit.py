
class Vehicle(object):
    
    def __init__(self):
        self.mobile = True
        
class Car(Vehicle):
    
    def __init__(self):
        Vehicle.__init__(self)
        self.car_init()
        
# BAD: Car.__init__ is not called.
class SportsCar(Car, Vehicle):
    
    def __init__(self):
        Vehicle.__init__(self)
        self.sports_car_init()
        
# GOOD: Car.__init__ is called correctly.
class FixedSportsCar(Car, Vehicle):
    
    def __init__(self):
        Car.__init__(self)
        self.sports_car_init()
        
