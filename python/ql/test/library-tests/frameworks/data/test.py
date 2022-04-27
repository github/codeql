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