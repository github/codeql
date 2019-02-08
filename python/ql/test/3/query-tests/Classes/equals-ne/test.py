
class OK:

    def __eq__(self, other):
        return False

class NotOK2:

    def __ne__(self, other):
        return True
