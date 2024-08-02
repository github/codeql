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

from testlib import CallFilter

CallFilter.arityOne(one, two) # NO match
CallFilter.arityOne(one) # Match
CallFilter.twoOrMore(one) # NO match
CallFilter.twoOrMore(one, two) # Match
CallFilter.twoOrMore(one, two, three) # Match

from testlib import CommonTokens

async def async_func():
    prom = CommonTokens.makePromise(1);
    val = await prom

inst = CommonTokens.Class()

class SubClass (CommonTokens.Super):
    pass

sub = SubClass()

class Sub2Class (CommonTokens.Class):
    pass

sub2 = Sub2Class()

val = inst.foo()

from testlib import ArgPos

arg_pos = ArgPos(); val = arg_pos.self_thing(arg, named=2);

class SubClass (ArgPos.MyClass):
    def foo(self, arg, named=2, otherName=3):
        pass

    def secondAndAfter(self, arg1, arg2, arg3, arg4, arg5):
        pass

ArgPos.anyParam(arg1, arg2, name=namedThing)
ArgPos.anyNamed(arg4, arg5, name=secondNamed)

from testlib import Steps

mySink(Steps.preserveTaint(getSource())) # FLOW
mySink(Steps.preserveTaint("safe", getSource())) # NO FLOW

Steps.taintIntoCallback(
    getSource(),
    lambda x: mySink(x), # FLOW
    lambda y: mySink(y), # FLOW
    lambda z: mySink(z) # NO FLOW
)

mySink(Steps.preserveArgZeroAndTwo(getSource())) # FLOW
mySink(Steps.preserveArgZeroAndTwo("foo", getSource())) # NO FLOW
mySink(Steps.preserveArgZeroAndTwo("foo", "bar", getSource())) # FLOW

mySink(Steps.preserveAllButFirstArgument(getSource())) # NO FLOW
mySink(Steps.preserveAllButFirstArgument("foo", getSource())) # FLOW
mySink(Steps.preserveAllButFirstArgument("foo", "bar", getSource())) # FLOW

CallFilter.arityOne(one) # match
CallFilter.arityOne(one=one) # NO match
CallFilter.arityOne(one, two=two) # match - on both the named and positional arguments
CallFilter.arityOne(one=one, two=two) # NO match

from foo1.bar import baz1
baz1(baz1) # no match, and that's the point.

from foo2.bar import baz2
baz2(baz2) # match

class OtherSubClass (ArgPos.MyClass):
    def otherSelfTest(self, arg, named=2, otherName=3): # test that Parameter[0] hits `arg`.
        pass

    def anyParam(self, param1, param2): # Parameter[any] matches all non-self parameters
        pass

    def anyNamed(self, name1, name2=2): # Parameter[any-named] matches all non-self named parameters
        pass

import testlib as testlib
import testlib.nestedlib as testlib2
import otherlib as otherlib

testlib.fuzzyCall(getSource()) # NOT OK
testlib2.fuzzyCall(getSource()) # NOT OK
testlib.foo.bar.baz.fuzzyCall(getSource()) # NOT OK
testlib.foo().bar().fuzzyCall(getSource()) # NOT OK
testlib.foo(lambda x: x.fuzzyCall(getSource())) # NOT OK
otherlib.fuzzyCall(getSource()) # OK

# defining sources through content steps

# dictionaries
testlib.source_dict["key"].func() # source
testlib.source_dict["safe"].func() # not a source
lambda k: testlib.source_dict_any[k].func() # source

# TODO: implement support for lists
lambda i: testlib.source_list[i].func()

# TODO: implement support for tuples
testlib.source_tuple[0].func() # a source
testlib.source_tuple[1].func() # not a source
