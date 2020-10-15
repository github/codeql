def check_output(outtext, f):
    if outtext == "OK\n":
        pass
    else:
        raise RuntimeError("Function failed", outtext, f.__name__)


def check_test_function(f):
    from io import StringIO
    import sys

    capturer = StringIO()
    old_stdout = sys.stdout
    sys.stdout = capturer
    f()
    sys.stdout = old_stdout
    check_output(capturer.getvalue(), f)


def check_async_test_function(f):
    from io import StringIO
    import sys
    import asyncio

    capturer = StringIO()
    old_stdout = sys.stdout
    sys.stdout = capturer
    asyncio.run(f())
    sys.stdout = old_stdout
    check_output(capturer.getvalue(), f)


def check_tests_valid(testFile):
    import importlib

    tests = importlib.import_module(testFile)
    for i in dir(tests):
        # print("Considering", i)
        if i.startswith("test_"):
            item = getattr(tests, i)
            if callable(item):
                print("Checking", testFile, item.__name__)
                check_test_function(item)

        elif i.startswith("atest_"):
            item = getattr(tests, i)
            if callable(item):
                print("Checking", testFile, item.__name__)
                check_async_test_function(item)


if __name__ == "__main__":
    check_tests_valid("classes")
    check_tests_valid("test")
    check_tests_valid("argumentPassing")
