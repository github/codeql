import sys

def redirect_to_file(function, args, kwargs, filename):
    with open(filename) as out:
        orig_stdout = sys.stdout
        sys.stdout = out
        try:
            function(*args, **kwargs)
        finally:
            sys.stdout = orig_stdout

