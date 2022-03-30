# Example module - finance.py

__all__ = ['tax1', 'tax2']  #defines the names to import when '*' is used

tax1 = 5
tax2 = 10
def cost(): return 'cost'

# Imported into code using

from finance import *

print tax1
print tax2