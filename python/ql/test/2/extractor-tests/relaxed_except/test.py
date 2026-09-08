# When extracting Python 2, `except A, e:` binds `e`. It is not a PEP 758
# unparenthesized tuple of exception types, which is what the same syntax means
# from Python 3.14 on.
try:
    unlikely()
except ValueError, err:
    print err

# `as` means the same thing in every version.
try:
    unlikely()
except ValueError as other:
    print other

# A parenthesized tuple is several types, and binds nothing.
try:
    unlikely()
except (ValueError, TypeError):
    pass
