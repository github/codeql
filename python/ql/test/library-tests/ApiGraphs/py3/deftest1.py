from mypkg import foo  #$ use=moduleImport("mypkg").getMember("foo")

def callback(x): #$ use=moduleImport("mypkg").getMember("foo").getMember("bar").getParameter(0).getParameter(0)
    x.baz() #$ use=moduleImport("mypkg").getMember("foo").getMember("bar").getParameter(0).getParameter(0).getMember("baz").getReturn()

foo.bar(callback) #$ def=moduleImport("mypkg").getMember("foo").getMember("bar").getParameter(0) use=moduleImport("mypkg").getMember("foo").getMember("bar").getReturn()

def callback2(x): #$ use=moduleImport("mypkg").getMember("foo").getMember("baz").getParameter(0).getMember("c").getParameter(0)
    x.baz2() #$ use=moduleImport("mypkg").getMember("foo").getMember("baz").getParameter(0).getMember("c").getParameter(0).getMember("baz2").getReturn()

mydict = {
  "c": callback2, #$ def=moduleImport("mypkg").getMember("foo").getMember("baz").getParameter(0).getMember("c")
  "other": "whatever" #$ def=moduleImport("mypkg").getMember("foo").getMember("baz").getParameter(0).getMember("other")
}

foo.baz(mydict) #$ def=moduleImport("mypkg").getMember("foo").getMember("baz").getParameter(0) use=moduleImport("mypkg").getMember("foo").getMember("baz").getReturn()

def callback3(x): #$ use=moduleImport("mypkg").getMember("foo").getMember("baz").getParameter(0).getMember("third").getParameter(0)
    x.baz3() #$ use=moduleImport("mypkg").getMember("foo").getMember("baz").getParameter(0).getMember("third").getParameter(0).getMember("baz3").getReturn()

mydict.third = callback3 #$ def=moduleImport("mypkg").getMember("foo").getMember("baz").getParameter(0).getMember("third")

foo.blab(mydict) #$ def=moduleImport("mypkg").getMember("foo").getMember("blab").getParameter(0) use=moduleImport("mypkg").getMember("foo").getMember("blab").getReturn()

def callback4(x): #$ use=moduleImport("mypkg").getMember("foo").getMember("quack").getParameter(0).getParameter(0)
    x.baz4() #$ use=moduleImport("mypkg").getMember("foo").getMember("quack").getParameter(0).getParameter(0).getMember("baz4").getReturn()

otherDict = {
    # TODO: Backtracking through a property set using a dict doesn't work, but I can backtrack through explicit property writes, e.g. the `otherDict.fourth` below.
    # TODO: There is a related TODO in ApiGraphs.qll
    "blab": "whatever"
}
otherDict.fourth = callback4

foo.quack(otherDict.fourth) #$ def=moduleImport("mypkg").getMember("foo").getMember("quack").getParameter(0) use=moduleImport("mypkg").getMember("foo").getMember("quack").getReturn()

def namedCallback(myName, otherName): 
    # Using named parameters: 
    myName() #$ use=moduleImport("mypkg").getMember("foo").getMember("blob").getParameter(0).getKeywordParameter("myName").getReturn()
    otherName() #$ use=moduleImport("mypkg").getMember("foo").getMember("blob").getParameter(0).getKeywordParameter("otherName").getReturn()
    # Using numbered parameters: 
    myName() #$ use=moduleImport("mypkg").getMember("foo").getMember("blob").getParameter(0).getParameter(0).getReturn()
    otherName() #$ use=moduleImport("mypkg").getMember("foo").getMember("blob").getParameter(0).getParameter(1).getReturn()

foo.blob(namedCallback) #$ use=moduleImport("mypkg").getMember("foo").getMember("blob").getReturn()

foo.named(myName = 2) #$ def=moduleImport("mypkg").getMember("foo").getMember("named").getKeywordParameter("myName")


def recusisionCallback(x):
    x.recursion() #$ use=moduleImport("mypkg").getMember("foo").getMember("rec").getParameter(0).getMember("callback").getParameter(0).getMember("recursion").getReturn()
    x.recursion() #$ use=moduleImport("mypkg").getMember("foo").getMember("rec").getParameter(0).getMember("rec1").getMember("callback").getParameter(0).getMember("recursion").getReturn()
    x.recursion() #$ use=moduleImport("mypkg").getMember("foo").getMember("rec").getParameter(0).getMember("rec1").getMember("rec2").getMember("callback").getParameter(0).getMember("recursion").getReturn()
    x.recursion() #$ use=moduleImport("mypkg").getMember("foo").getMember("rec").getParameter(0).getMember("rec1").getMember("rec2").getMember("rec1").getMember("callback").getParameter(0).getMember("recursion").getReturn()

recursiveDict = {};
recursiveDict.callback = recusisionCallback;
recursiveDict.rec1 = recursiveDict;
recursiveDict.rec2 = recursiveDict;

foo.rec(recursiveDict); #$ def=moduleImport("mypkg").getMember("foo").getMember("rec").getParameter(0)