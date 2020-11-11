This test shows how we handle modules the shadow a module in the standard library.

Because we have a `cmd.py` file, whenever the python interpreter sees `import cmd`, that is the file that will be used! --

* `python test_ok.py` works as intended, and prints `Foo`
* `python test_fail.py` raises an exception, since it imports `pdb.py` from the standard library, which (at least in Python 3.8) tries to import `cmd.py` from the standard library, but instead is served our `cmd.py` module. Therefore it fails with `AttributeError: module 'cmd' has no attribute 'Cmd'`
