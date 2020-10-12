import mypkg
print(mypkg.foo)  # 42
try:
    print(mypkg.bar)
except AttributeError as e:
    print(e)  # module 'mypkg' has no attribute 'bar'
