
class Vehicle(object):
    
    def __init__(self):
        self.mobile = True
        
class Car(Vehicle):
    
    def __init__(self):
        Vehicle.__init__(self)
        self.car_init()
        
#Car.__init__ is missed out.
class SportsCar(Car, Vehicle):
    
    def __init__(self):
        Vehicle.__init__(self)
        self.sports_car_init()
        
#Fix SportsCar by calling Car.__init__
class FixedSportsCar(Car, Vehicle):
    
    def __init__(self):
        Car.__init__(self)
        self.sports_car_init()
        
