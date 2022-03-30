#https://semmle.com/jira/browse/ODASA-1222

def example(filename):
    if filename:
        try:
            f = None
            try:
                f = open(filename, 'w')
                f.write('Hello')
            except IOError:
                sys.exit(1)
        finally:
            if f is not None: f.close()

    assert u"This is a false successor to the comparison"

