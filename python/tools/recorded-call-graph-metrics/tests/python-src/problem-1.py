class Foo:
    def __init__(self):
        self.list = []

    def func(self, kwargs=None, result_callback=None):
        self.list.append((kwargs or {}, result_callback))


foo = Foo()
foo.func()

"""
Has problematic bytecode, since to find out what method is called from instruction 16, we need
to traverse the JUMP_IF_TRUE_OR_POP which requires some more sophistication.

Disassembly of <code object func at 0x7f98f64ee030, file "example/problem-1.py", line 5>:
  6           0 LOAD_FAST                0 (self)
              2 LOAD_ATTR                0 (list)
              4 LOAD_METHOD              1 (append)
              6 LOAD_FAST                1 (kwargs)
              8 JUMP_IF_TRUE_OR_POP     12
             10 BUILD_MAP                0
        >>   12 LOAD_FAST                2 (result_callback)
             14 BUILD_TUPLE              2
             16 CALL_METHOD              1
"""
