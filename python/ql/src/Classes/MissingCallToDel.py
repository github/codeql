
class Vehicle(object):
    
    def __del__(self):
        recycle(self.base_parts)
        
class Car(Vehicle):
    
    def __del__(self):
        recycle(self.car_parts)
        Vehicle.__del__(self)
        
#Car.__del__ is missed out.
class SportsCar(Car, Vehicle):
    
    def __del__(self):
        recycle(self.sports_car_parts)
        Vehicle.__del__(self)
        
#Fix SportsCar by calling Car.__del__
class FixedSportsCar(Car, Vehicle):
    
    def __del__(self):
        recycle(self.sports_car_parts)
        Car.__del__(self)
        
