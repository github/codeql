'''
A long docstring...

The Zen of Python, by Tim Peters

Beautiful is better than ugly.
Explicit is better than implicit.
Simple is better than complex.
Complex is better than complicated.
Flat is better than nested.
Sparse is better than dense.
Readability counts.
Special cases aren't special enough to break the rules.
Although practicality beats purity.
Errors should never pass silently.
Unless explicitly silenced.
In the face of ambiguity, refuse the temptation to guess.
There should be one-- and preferably only one --obvious way to do it.
Although that way may not be obvious at first unless you're Dutch.
Now is better than never.
Although never is often better than *right* now.
If the implementation is hard to explain, it's a bad idea.
If the implementation is easy to explain, it may be a good idea.
Namespaces are one honking great idea -- let's do more of those!
'''

#25 lines of docstring in a 50 line module: 50%
#12 lines of code in a 50 line module: 24%
#6 lines of comment in a 50 line module: 12%

#And some code
import nonexistent

def function():
    meaning_of_life = 42
    return meaning_of_life

class C:

    def __init__(self):
        stuff()
        more_stuff()
        yet_more_stuff()
        #Pointless return
        return

    def m(self):
        pass

# A comment on the last line
