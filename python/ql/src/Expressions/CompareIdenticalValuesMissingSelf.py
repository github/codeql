
class Customer:

    def __init__(self, data):
        self.data = data

    def check_data(self, data):
        if data != data:  # Forgotten 'self'
            raise Exception("Invalid data!")

#Fixed version

class Customer:

    def __init__(self, data):
        self.data = data

    def check_data(self, data):
        if self.data != data:
            raise Exception("Invalid data!")
