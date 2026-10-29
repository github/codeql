

class Vehicle(object):
    pass
        
class Car(Vehicle):
    
    def __init__(self):
        #This is OK provided that Car is not subclassed.
        super(Vehicle, self).__init__()
        self.car_init()
        
class StatusSymbol(object):
    
    def __init__(self):
        super(StatusSymbol, self).__init__()
        self.show_off()
        
class SportsCar(Car, StatusSymbol):
    
    def __init__(self):
        #This will not call StatusSymbol.__init__()
        super(SportsCar, self).__init__()
        self.sports_car_init()

        
#Fix Car by passing Car to super().
#SportsCar does not need to be changed.
class Car(Car, Vehicle):
    
    def __init__(self):
        super(Car, self).__init__()
        self.car_init()
        
