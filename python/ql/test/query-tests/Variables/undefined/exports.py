__all__ = ["foo", "bar", "baz", "quux", "blat", "frob", "nosuch", "i_got_it_elsewhere"]

with open("foo.txt") as f:
    foo = f.read()

b = open("bar.txt")
bar = b.read()

baz = open("baz.txt")

from unknown_module import unknown_value

quux = 5 + unknown_value

blat = str(5)

frob = "5"

from unknown_module import i_got_it_elsewhere
