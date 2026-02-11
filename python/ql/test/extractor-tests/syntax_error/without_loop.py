# The following constructs are syntax errors in Python, as they are not inside a loop.
# However, our parser does not consider this code to be syntactically incorrect.
# Thus, this test is really observing that allowing these constructs does not break any other parts
# of the extractor.

if True:
    break

if True:
    continue
