
class Vehicle(object):
    
    def __del__(self):
        recycle(self.base_parts)
        
class Car(Vehicle):
    
    def __del__(self):
        recycle(self.car_parts)
        Vehicle.__del__(self)
        
#BAD: Car.__del__ is not called.
class SportsCar(Car, Vehicle):
    
    def __del__(self):
        recycle(self.sports_car_parts)
        Vehicle.__del__(self)
        
#GOOD: Car.__del__ is called correctly.
class FixedSportsCar(Car, Vehicle):
    
    def __del__(self):
        recycle(self.sports_car_parts)
        Car.__del__(self)
        
