if 1:
    "double quotes"
if 2:
    'single quotes'
if 3:
    """triple double quotes (sextuple quotes?)"""
if 4:
    '''triple single quotes'''
if 5:
    r"raw string"
if 6:
    b"byte string"
if 7:
    u"unicode string"
if 8:
    br"raw byte string"
if 9:
    "Let's put some control\tcharacters in here\n"
if 10:
    """
    Multiline
    string
    time
    """
if 11:
    "escaped \"quotes\" here"
if 12:
    """Unescaped "quotes" inside triple quotes"""
if 13:
    "string" """concatenation""" 'here' '''oh yeah'''
if 14:
    f"format string with no funny business"
if 15:
    f"format string with {1} interpolation"
if 16:
    f"{2}{3}{4}"
if 17:
    f"and a format string with {'nested'} string"
if 18:
    f"foo{x}bar" "regular string"
if 19:
    pass
    # This doesn't quite give the right result, but it's close enough.
    #f"no interpolation" ' but still implicit concatenation'
if 20:
    f"{9}" "blah" f'{10}'
if 21:
    f"format{129}string" "not format"
if 21.1:
    # regression from https://github.com/github/codeql/issues/9940
    f"format{123}string" f"technically format string\n"
if 22:
    "again not format" f"format again{foo}hello"
if 23:
    f"""f-string with {"inner " 'implicit ' '''concatenation'''} how awful"""
if 24:
    f'''oh no python { f'why do you {"allow"} such'} absolute horrors?'''
if 25:
    b"""5""" b"byte format"
if 26:
    r'X(\u0061|a)*Y'
if 27:
    f"""triple-quoted {11}""f-st""" fr"""ri'''ng\\\\\""{12} with an inner quoted part"""
if 28:
    f'{value:{width + padding!r}.{precision}}'
if 29:
    f'{1,}'
if 30:
    fr"""quotes before interpolation "{123}" are okay."""
if 31:
    fr"""backslash before an interpolation \{456}\ are okay."""
if 32:
    f''
if 33:
    ''
if 34:
    b'\xc5\xe5'
if 35:
    f"{x=}"
if 36:
    r"a\"a"
if 37:
    r'a\'a'
if 38:
    r'a\\'
if 39:
    r'a\
    '
