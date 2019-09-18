# Regression test for a false-positive in 'Uninitialized Local'

def func():
    safe = 0
    for i in []:
        safe = 1
        if True:
            pass
    print safe # wrongly flagged

from module1 import *

def func2():
    os

def findPluginJars(dir):
  return filter(lambda y: y,
     (os.path.join(root, f) for root, _, files in os.walk(dir + '/plugins') for f in files))
