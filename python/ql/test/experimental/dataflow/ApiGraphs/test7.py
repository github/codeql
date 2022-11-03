from mypkg import foo #$ use=moduleImport("mypkg").getMember("foo")

print(foo) #$ use=moduleImport("mypkg").getMember("foo") // 42

import mypkg.foo #$ use=moduleImport("mypkg")
print(foo) #$ use=moduleImport("mypkg").getMember("foo") // 42
print(mypkg.foo) #$ use=moduleImport("mypkg").getMember("foo") // <module 'mypkg.foo' ...

from mypkg import foo #$ use=moduleImport("mypkg").getMember("foo")
print(foo) #$ use=moduleImport("mypkg").getMember("foo") // <module 'mypkg.foo' ...
