from . import helper

def use_relative():
    tainted = source()
    helper.process(tainted)
