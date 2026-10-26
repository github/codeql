
#Interoperate with very old versions of Python (pre 2.3)
try:
    True
except NameError:
    __builtins__.True = 1==1
