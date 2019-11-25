try:
    input = raw_input
except NameError:
    pass

def use_of_input():
    return input()

print(use_of_input())

