from .. import helper

def use_multi_level_relative():
    tainted = source()
    helper.process2(tainted)
