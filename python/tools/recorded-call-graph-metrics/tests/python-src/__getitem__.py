class Foo:
    def __getitem__(self, key):
        print("__getitem__")


foo = Foo()
foo["key"]  # this is recorded as a call :)
