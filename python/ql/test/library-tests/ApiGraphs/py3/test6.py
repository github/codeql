import mypkg #$ use=moduleImport("mypkg")

print(mypkg.foo) #$ use=moduleImport("mypkg").getMember("foo") // 42

import mypkg.foo #$ use=moduleImport("mypkg")
print(mypkg.foo) #$ use=moduleImport("mypkg").getMember("foo") // <module 'mypkg.foo' ...
