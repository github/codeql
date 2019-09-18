class Mammal(object):

    def __init__(self, milk = 0):
        self.milk = milk


class Cow(Mammal):

    def __init__(self):
        Mammal.__init__(self)

    def milk(self):
        return "Milk"

#Cow().milk() will raise an error as Cow().milk is the 'milk' attribute
#set in Mammal.__init__, not the 'milk' method defined on Cow.

