from testlib import getSource, mySink, alias

x = getSource()
mySink(x)

mySink(foo=x) # OK
mySink(sinkName=x) # NOT OK

mySink(alias()) # NOT OK
mySink(alias().chain()) # NOT OK
mySink(alias().chain().chain()) # NOT OK
mySink(alias().chain().safeThing()) # OK

from testlib import Args

Args.arg0(one, two, three, four, five)
Args.arg1to3(one, two, three, four, five)
Args.lastarg(one, two, three, four, five)
Args.nonFist(first, second)

from testlib import Callbacks

Callbacks.first(lambda one, two, three, four, five: 0)
Callbacks.param1to3(lambda one, two, three, four, five: 0)
Callbacks.nonFirst(lambda first, second: 0)