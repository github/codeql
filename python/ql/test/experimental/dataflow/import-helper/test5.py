import mypkg

print(mypkg.foo)  # 42
try:
    print(mypkg.bar)
except AttributeError as e:
    print(e)  # module 'mypkg' has no attribute 'bar'

from mypkg import bar as _bar
print(mypkg.bar)  # <module 'mypkg.bar' ...
