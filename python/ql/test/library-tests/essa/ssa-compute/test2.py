def func(x): # $ def=x
    try:
        with Thing() as y: # $ def=y
            y.foo(x, 0) # $ def-use=x:1 def-use=y:3
            while not x.attribute: # $ use-use=x:4 use-use=x:7
                y.bar() # $ use-use=y:4 use-use=y:6
                print(x) # $ use-use=x:5
    finally:
        pass

def func(x): # $ def=x
    try:
        with Thing() as y: # $ def=y
            y.foo(x, some_var) # $ def-use=x:11 def-use=y:13
            while not x.attribute: # $ use-use=x:14 use-use=x:17
                y.bar() # $ use-use=y:16 MISSING: use-use=y:14
                print(x) # $ use-use=x:15
    finally:
        pass

def func(x): # $ def=x
    try:
        with Thing() as y: # $ def=y
            y.foo(x, some_var.some_attr) # $ def-use=x:21 def-use=y:23
            while not x.attribute: # $ use-use=x:27 MISSING: use-use=x:24
                y.bar() # $ use-use=y:26 MISSING: use-use=y:24
                print(x) # $ use-use=x:25
    finally:
        pass
