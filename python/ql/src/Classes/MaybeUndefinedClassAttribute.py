class Spam:

    def __init__(self):
        self.spam = 'spam, spam, spam'

    def set_eggs(eggs):
        self.eggs = eggs

    def __str__(self):
        return '%s and %s' % (self.spam, self.eggs) # Maybe uninitialized attribute 'eggs'

#Fixed version

class Spam:

    def __init__(self):
        self.spam = 'spam, spam, spam'
        self.eggs = None

    def set_eggs(eggs):
        self.eggs = eggs

    def __str__(self):
        return '%s and %s' % (self.spam, self.eggs) # OK

