


def exec_used(val):
    exec (val)

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

import fake_six

#ODASA 3737
def g(arg = ''):
    if isinstance(arg, fake_six.string_types):
        arg = [ arg ]
    for msg in arg:
        pass
