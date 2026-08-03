import re

#Unmatchable caret
re.compile(b' ^abc') # $ Alert[py/regex/unmatchable-caret]
re.compile(b"(?s) ^abc") # $ Alert[py/regex/unmatchable-caret]
re.compile(b"\[^123]") # $ Alert[py/regex/unmatchable-caret]

#Likely false positives for unmatchable caret
re.compile(b"[^123]")
re.compile(b"[123^]")
re.sub(b'(?m)^(?!$)', indent*' ', s)
re.compile(b"()^abc")
re.compile(b"(?:(?:\n\r?)|^)( *)\S")
re.compile(b"^diff (?:-r [0-9a-f]+ ){1,2}(.*)$")

#Backspace escape
re.compile(br"[\b\t ]") # $ Alert[py/regex/backspace-escape] # Should warn
re.compile(br"E\d+\b.*") # Fine
re.compile(br"E\d+\b[ \b\t]") # $ Alert[py/regex/backspace-escape] #Both

#Missing part in named group
re.compile(br'(P<name>[\w]+)') # $ Alert[py/regex/incomplete-special-group]
re.compile(br'(_(P<name>[\w]+)|)') # $ Alert[py/regex/incomplete-special-group]
#This is OK...
re.compile(br'(?P<name>\w+)')


#Unmatchable dollar
re.compile(b"abc$ ") # $ Alert[py/regex/unmatchable-dollar]
re.compile(b"abc$ (?s)") # $ Alert[py/regex/unmatchable-dollar]
re.compile(b"\[$]  ") # $ Alert[py/regex/unmatchable-dollar]

#Not unmatchable dollar
re.match(b"[$]  ", b"$  ")
re.match(b"\$  ", b"$  ")
re.match(b"abc$(?m)", b"abc")
re.match(b"abc$()", b"abc")
re.match(b"((a$)|b)*", b"bba")
re.match(b"((a$)|b){4}", b"bbba") # Inspired by FP report here: https://github.com/github/codeql/issues/2403
re.match(b"((a$).*)", b"a")
re.match("(\Aab$|\Aba$)$\Z", "ab")
re.match(b"((a$\Z)|b){4}", b"bbba")
re.match(b"(a){00}b", b"b")

#Duplicate character in set
re.compile(b"[AA]") # $ Alert[py/regex/duplicate-in-character-class]
re.compile(b"[000]") # $ Alert[py/regex/duplicate-in-character-class]
re.compile(b"[-0-9-]") # $ Alert[py/regex/duplicate-in-character-class]

#Possible false positives
re.compile(b"[S\S]")
re.compile(b"[0\000]")
re.compile(b"[\0000]")
re.compile(b"[^^]")
re.compile(b"[-0-9]")
re.compile(b"[]]")
re.compile(b"^^^x.*")
re.compile(b".*x$$$")
re.compile(b"x*^y")
re.compile(b"x$y*")

# False positive for unmatchable caret
re.compile(br'(?!DEFAULT_PREFS)(?!CAN_SET_ANON)^[A-Z_]+$')

#Equivalent for unmatchable dollar
re.compile(br'^[A-Z_]+(?!DEFAULT_PREFS)(?!CAN_SET_ANON)$')

#And for negative look-behind assertions
re.compile(br'(?<!DEFAULT_PREFS)(?<!CAN_SET_ANON)^[A-Z_]+$')
re.compile(br'^[A-Z_]+(?<!DEFAULT_PREFS)(?<!CAN_SET_ANON)$')


#OK
re.compile(br'(?=foo)^\w+')
re.compile(br'\w+$(?<=foo)')


#Not OK
re.compile(br'(?<=foo)^\w+') # $ Alert[py/regex/unmatchable-caret]
re.compile(br'\w+$(?=foo)') # $ Alert[py/regex/unmatchable-dollar]


#OK -- ODASA-ODASA-3968
re.compile('(?:[^%]|^)?%\((\w*)\)[a-z]')

#ODASA-3985
#Half Surrogate pairs
re.compile(u'[\uD800-\uDBFF][\uDC00-\uDFFF]')
#Outside BMP
re.compile(u'[\U00010000-\U0010ffff]')

#ODASA-6394  -- Flags defined by keyword
REGEX0 = re.compile(r'''   ^\s*    ''', re.VERBOSE)

REGEX1 = re.compile(r'''   ^\s*    ''', flags=re.VERBOSE)

REGEX2 = re.compile(r'''
            ^\s*
            (?P<modifier>[+-]?)
            (?: (?P<week>   \d+ (?:\.\d*)? ) \s* [wW]  )? \s*
            (?: (?P<day>    \d+ (?:\.\d*)? ) \s* [dD]  )? \s*
            (?: (?P<hour>   \d+ (?:\.\d*)? ) \s* [hH]  )? \s*
            (?: (?P<minute> \d+ (?:\.\d*)? ) \s* [mM]  )? \s*
            (?: (?P<second> \d+ (?:\.\d*)? ) \s* [sS]  )? \s*
            $
            ''',
            flags=re.VERBOSE)

REGEX3 = re.compile(r'''
            ^\s*
            (?P<modifier>[+-]?)
            (?: (?P<week>   \d+ (?:\.\d*)? ) \s* [wW]  )? \s*
            (?: (?P<day>    \d+ (?:\.\d*)? ) \s* [dD]  )? \s*
            (?: (?P<hour>   \d+ (?:\.\d*)? ) \s* [hH]  )? \s*
            (?: (?P<minute> \d+ (?:\.\d*)? ) \s* [mM]  )? \s*
            (?: (?P<second> \d+ (?:\.\d*)? ) \s* [sS]  )? \s*
            $
            ''',
            re.VERBOSE)

#ODASA-6780
DYLIB_RE = re.compile(r"""(?x)
(?P<location>^.*)(?:^|/)
(?P<name>
    (?P<shortname>\w+?)
    (?:\.(?P<version>[^._]+))?
    (?:_(?P<suffix>[^._]+))?
    \.dylib$
)
""")

#ODASA-6786
VERBOSE_REGEX = r"""
        \[                                 # [
        (?P<header>[^]]+)                  # very permissive!
        \]                                 # ]
        """ # $ Alert[py/regex/duplicate-in-character-class]

# Compiled regular expression marking it as verbose
ODASA_6786 = re.compile(VERBOSE_REGEX, re.VERBOSE)

#Named group with caret and empty choice.
re.compile(r'(?:(?P<n1>^(?:|x)))')

#Potentially mis-parsed character set
re.compile(r"\[(?P<txt>[^[]*)\]\((?P<uri>[^)]*)")

#Allow unicode in raw strings
re.compile(r"[\U00010000-\U0010FFFF]")
re.compile(r"[\u0000-\uFFFF]")

#Allow unicode names
re.compile(r"[\N{degree sign}\N{EM DASH}]")

#Lookahead assertions. None of these are unmatchable dollars:
re.compile(r"^(?=a$)[ab]")
re.compile(r"^(?!a$)[ab]")

#Lookbehind assertions. None of these are unmatchable carets:
re.compile(r"(?<=^a)a")
re.compile(r"(?<!^a)a")
