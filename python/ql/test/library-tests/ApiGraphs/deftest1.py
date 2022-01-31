from mypkg import foo  #$ use=moduleImport("mypkg").getMember("foo")

def callback(x): #$ use=moduleImport("mypkg").getMember("foo").getMember("bar").getParameter(0).getParameter(0)
    x.baz() #$ use=moduleImport("mypkg").getMember("foo").getMember("bar").getParameter(0).getParameter(0).getMember("baz").getReturn()

foo.bar(callback) #$ def=moduleImport("mypkg").getMember("foo").getMember("bar").getParameter(0) use=moduleImport("mypkg").getMember("foo").getMember("bar").getReturn()
