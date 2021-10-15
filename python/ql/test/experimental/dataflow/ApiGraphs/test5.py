import mypkg #$ use=moduleImport("mypkg")

print(mypkg.foo) #$ use=moduleImport("mypkg").getMember("foo") // 42
try:
    print(mypkg.bar) #$ use=moduleImport("mypkg").getMember("bar")
except AttributeError as e: #$ use=moduleImport("builtins").getMember("AttributeError")
    print(e)  #$ use=moduleImport("builtins").getMember("print").getReturn() // module 'mypkg' has no attribute 'bar'

from mypkg import bar as _bar #$ use=moduleImport("mypkg").getMember("bar")
print(mypkg.bar) #$ use=moduleImport("mypkg").getMember("bar") // <module 'mypkg.bar' ...
