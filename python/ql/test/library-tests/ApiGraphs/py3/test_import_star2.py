# Star imports in local scope

hello2() 

def foo():
    from unknown2 import * #$ use=moduleImport("unknown2")
    world2() #$ use=moduleImport("unknown2").getMember("world2").getReturn()
    bar2 = 5
    bar2
    non_module_member2
    print(bar2) #$ use=moduleImport("builtins").getMember("print").getReturn()

def quux2():
    global non_module_member2
    non_module_member2 = 5
