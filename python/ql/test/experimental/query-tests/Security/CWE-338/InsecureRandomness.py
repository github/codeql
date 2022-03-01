import random

def generatePassword():
    # BAD: the random is not cryptographically secure
    return random.random()
