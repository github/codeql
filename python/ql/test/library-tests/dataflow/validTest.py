import sys

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


def check_tests_valid_after_version(testFile, version):

    if sys.version_info[:2] >= version:
        print("INFO: Will run tests in", testFile, "since we're running Python", version, "or newer")
        check_tests_valid(testFile)
    else:
        print("WARN: Will not run tests in", testFile, "since we're running Python", sys.version_info[:2], "and need", version, "or newer")

if __name__ == "__main__":
    check_tests_valid("coverage.classes")
    check_tests_valid("coverage.test")
    check_tests_valid("coverage.argumentPassing")
    check_tests_valid("coverage.datamodel")
    check_tests_valid("coverage.test_builtins")
    check_tests_valid("coverage.loops")
    check_tests_valid("coverage-py2.classes")
    check_tests_valid("coverage-py3.classes")
    check_tests_valid("variable-capture.in")
    check_tests_valid("variable-capture.nonlocal")
    check_tests_valid("variable-capture.global")
    check_tests_valid("variable-capture.dict")
    check_tests_valid("variable-capture.test_collections")
    check_tests_valid("variable-capture.by_value")
    check_tests_valid("variable-capture.test_library_calls")
    check_tests_valid("variable-capture.test_fields")
    check_tests_valid("module-initialization.multiphase")
    check_tests_valid("fieldflow.test")
    check_tests_valid("fieldflow.test_dict")
    check_tests_valid_after_version("match.test", (3, 10))
    check_tests_valid("exceptions.test")
    check_tests_valid_after_version("exceptions.test_group", (3, 11))

    # The below fails when trying to import modules
    # check_tests_valid("module-initialization.test")
    # check_tests_valid("module-initialization.testOnce")

    print("\n🎉 All tests passed 🎉")
