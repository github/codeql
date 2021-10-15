


def exec_used(val):
    exec(val)

#Top level print
import module

#This is OK
if __name__ == "__main__":
    for i in range(10):
        print ("Hello World")

#Iteration over string or list
def f(x):
    if x:
        s = u"Hello World"
    else:
        s = [ u'Hello', u'World']
    for thing in s:
        print (thing)












# Number of arguments in assignment statement is not mismatched because of starred argument.

def function_returning_tuple():
    return (1,2,3,4,5)

def function_returning_list():
    return [1,2,3,4,5]

def ok_multi_assignment():
    a, *b, c = (1,2,3,4,5)

def ok_indirect_multi_assignment1():
    a, *b, c = function_returning_tuple()

def ok_indirect_multi_assignment2():
    a, *b, c = function_returning_list()
