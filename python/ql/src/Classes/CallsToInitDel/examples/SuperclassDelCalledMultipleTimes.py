
#Calling a method multiple times by using explicit calls when a base uses super()
class Vehicle(object):
     
    def __del__(self):
        recycle(self.base_parts)
        super(Vehicle, self).__del__()
        
class Car(Vehicle):
    
    def __del__(self):
        recycle(self.car_parts)
        super(Car, self).__del__()
        
        
class SportsCar(Car, Vehicle):
    
    # BAD: Vehicle.__del__ will get called twice
    def __del__(self):
        recycle(self.sports_car_parts)
        Car.__del__(self)
        Vehicle.__del__(self)
        
        
# GOOD: super() is used ensuring each del method is called once.
class FixedSportsCar(Car, Vehicle):
    
    def __del__(self):
        recycle(self.sports_car_parts)
        super(SportsCar, self).__del__()
     

