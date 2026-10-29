
import sys

def my_print(*args):
    print (args)

def main():
    err = my_print(sys.argv)
    if err:
        sys.exit(err)


#FIXED VERSION
def main():
    my_print(sys.argv)
    #The rest of the code can be removed as None as always false

