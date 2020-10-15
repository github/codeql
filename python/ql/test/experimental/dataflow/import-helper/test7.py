from mypkg import foo

print(foo)  # 42

import mypkg.foo
print(foo)  # 42
print(mypkg.foo)  # <module 'mypkg.bar' ...

from mypkg import foo
print(foo)  # <module 'mypkg.bar' ...
