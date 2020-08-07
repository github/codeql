def check_output(s, f):
    if s == "OK\n":
        pass
    else:
        raise RuntimeError("Function failed", s, f)

def check_test_function(f):
    from io import StringIO
    import sys

    capturer = StringIO()
    old_stdout = sys.stdout
    sys.stdout = capturer
    f()
    sys.stdout = old_stdout
    check_output(capturer.getvalue(), f)

def check_classes_valid(testFile):
    # import python.ql.test.experimental.dataflow.coverage.classes as tests
    # import classes as tests
    import importlib
    tests = importlib.import_module(testFile)
    for i in dir(tests):
        # print("Considering", i)
        if i.startswith("test_"):
            item = getattr(tests,i)
            if callable(item):
                print("Checking", testFile, item)
                check_test_function(item)

if __name__ == '__main__':
    check_classes_valid("classes")
    check_classes_valid("test")
