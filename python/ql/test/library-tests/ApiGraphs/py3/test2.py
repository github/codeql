from mypkg import foo #$ use=moduleImport("mypkg").getMember("foo")
from mypkg import bar #$ use=moduleImport("mypkg").getMember("bar")
print(foo) #$ use=moduleImport("mypkg").getMember("foo")
print(bar) #$ use=moduleImport("mypkg").getMember("bar")
