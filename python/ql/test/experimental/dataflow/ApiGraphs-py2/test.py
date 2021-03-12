def python2_style():
    from __builtin__ import open #$ use=moduleImport("builtins").getMember("open")
    open("hello.txt") #$ use=moduleImport("builtins").getMember("open").getReturn()
