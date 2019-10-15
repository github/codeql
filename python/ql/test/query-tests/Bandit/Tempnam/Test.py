from os import tempnam
from os import tmpnam
import os

os.tmpnam()

tmpnam()

os.tempnam('dir1')
os.tempnam('dir1', 'prefix1')

tempnam('dir1')
tempnam('dir1', 'prefix1')
