import os
from os import popen
import os as o
from os import popen as pos

os.popen('/bin/uname -av')
popen('/bin/uname -av')
o.popen('/bin/uname -av')
pos('/bin/uname -av')
os.popen2('/bin/uname -av')
os.popen3('/bin/uname -av')
os.popen4('/bin/uname -av')

os.popen4('/bin/uname -av; rm -rf /')
os.popen4(some_var)
