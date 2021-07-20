# Star imports

from unknown import * #$ use=moduleImport("unknown")

# Currently missing, as we do not consider `hello` to be a `LocalSourceNode`, since it has flow
# going into it from its corresponding `GlobalSsaVariable`.
hello() #$ MISSING: use=moduleImport("unknown").getMember("hello").getReturn()

# We don't want our analysis to think that either `non_module_member` or `outer_bar` can
# come from `from unknown import *`
non_module_member

outer_bar = 5
outer_bar

def foo():
    world() #$ use=moduleImport("unknown").getMember("world").getReturn()
    bar = 5
    bar
    non_module_member
    print(bar) #$ use=moduleImport("builtins").getMember("print").getReturn()

def quux():
    global non_module_member
    non_module_member = 5
