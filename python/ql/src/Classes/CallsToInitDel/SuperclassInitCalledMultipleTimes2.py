
#Calling a method multiple times by using explicit calls when a base uses super()
class Vehicle(object):
     
    def __init__(self):
        super(Vehicle, self).__init__()
        self.mobile = True
        
class Car(Vehicle):
    
    def __init__(self):
        super(Car, self).__init__()
        self.car_init()
        
    def car_init(self):
        pass
        
class SportsCar(Car, Vehicle):
    
    # Vehicle.__init__ will get called twice
    def __init__(self):
        Vehicle.__init__(self)
        Car.__init__(self)
        self.sports_car_init()
        
    def sports_car_init(self):
        pass
        
#Fix SportsCar by using super()
class FixedSportsCar(Car, Vehicle):
    
    def __init__(self):
        super(SportsCar, self).__init__()
        self.sports_car_init()
        
    def sports_car_init(self):
        pass

