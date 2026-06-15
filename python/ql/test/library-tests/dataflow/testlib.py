def expects(n):
    def check_output(output):
        lines = output.splitlines()
        if all(s == "OK" for s in lines):
            if len(lines) == n:
                print("OK")
            else:
                print("Expected", n, "outputs but got", len(lines))
        else:
            print(list(s for s in lines if s != "OK"))

    def wrap(f):
        def wrapped(*args, **kwargs):
            from io import StringIO
            import sys

            capturer = StringIO()
            old_stdout = sys.stdout
            sys.stdout = capturer
            f(*args, **kwargs)
            sys.stdout = old_stdout
            check_output(capturer.getvalue())

        wrapped.__name__ = "[" + str(n) + "]" + f.__name__
        return wrapped

    return wrap
