class Spam:

    def __init__(self):
        self.spam = 'spam, spam, spam'

    def __str__(self):
        return '%s and %s' % (self.spam, self.eggs) # Uninitialized attribute 'eggs'

#Fixed version

class Spam:

    def __init__(self):
        self.spam = 'spam, spam, spam'
        self.eggs = None

    def __str__(self):
        return '%s and %s' % (self.spam, self.eggs) # OK

