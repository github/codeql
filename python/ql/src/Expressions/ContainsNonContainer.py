class NotAContainer(object):

    def __init__(self, *items):
        self.items = items

def main():
    cont = NotAContainer(1, 2, 3)
    if 2 in cont:
        print("2 in container")
