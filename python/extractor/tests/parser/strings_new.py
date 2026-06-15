if 1:
    fr"this is not a unicode escape but an interpolation: \N{AMPERSAND}"
if 2:
    f'also an interpolation: \\N{AMPERSAND}'
if 3:
    f'\\Nspam'
if 4:
    f"this is a unicode escape: \N{AMPERSAND}"
if 5:
    r"this is also not a unicode escape: \N{AMPERSAND}"
if 6:
    '\\N{AMPERSAND}'
if 7:
    '\\Nspam'
if 8:
    "this is also also a unicode escape: \N{AMPERSAND}"
if 9:
    rb"this is also not a unicode escape: \N{AMPERSAND}"
if 10:
    b'\\N{AMPERSAND}'
if 11:
    b'\\Nspam'
if 12:
    b"this is not a unicode escape because we are in a bytestring: \N{AMPERSAND}"
if 13:
    fr"""quotes before interpolation "{0}" are okay."""
if 14:
    fr"""backslash before an interpolation \{1}\ are okay."""
if 15:
    f"Yield inside an f-string: {yield 5} is allowed."
