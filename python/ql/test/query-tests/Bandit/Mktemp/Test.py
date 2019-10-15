from tempfile import mktemp
import tempfile.mktemp as mt
import tempfile as tmp

foo = 'hi'

mktemp(foo)
tempfile.mktemp('foo')
mt(foo)
tmp.mktemp(foo)
