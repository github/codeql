#Calling a method multiple times by using explicit calls when a base inherits from other base
class Vehicle(object):
    
    def __del__(self):
        recycle(self.base_parts)
        
        
class Car(Vehicle):
    
    def __del__(self):
        recycle(self.car_parts)
        Vehicle.__del__(self)
    
    
class SportsCar(Car, Vehicle):
    
    # Vehicle.__del__ will get called twice
    def __del__(self):
        recycle(self.sports_car_parts)
        Car.__del__(self)
        Vehicle.__del__(self)
        
        
#Fix SportsCar by only calling Car.__del__
class FixedSportsCar(Car, Vehicle):
    
    def __del__(self):
        recycle(self.sports_car_parts)
        Car.__del__(self)
