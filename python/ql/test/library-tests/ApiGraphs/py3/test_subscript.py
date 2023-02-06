import mypkg

def test_subscript():
    bar = mypkg.foo()["bar"] #$ use=moduleImport("mypkg").getMember("foo").getReturn().getASubscript()
    mypkg.foo()["baz"] = 42 #$ def=moduleImport("mypkg").getMember("foo").getReturn().getASubscript()
    mypkg.foo()["qux"] += 42 #$ use=moduleImport("mypkg").getMember("foo").getReturn().getASubscript()
    mypkg.foo()["qux"] += 42 #$ def=moduleImport("mypkg").getMember("foo").getReturn().getASubscript()
    mypkg.foo()[mypkg.index] = mypkg.value #$ def=moduleImport("mypkg").getMember("foo").getReturn().getASubscript()
