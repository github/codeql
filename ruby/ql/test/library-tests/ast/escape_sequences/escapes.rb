# Most comments indicate the contents of the string after MRI has parsed the
# escape sequences (i.e. what gets printed by `puts`), and that's what we expect
# `getConstantValue().getString()` to return.

# The only escapes in single-quoted strings are backslash and single-quote.
'\''        # '
'\"'        # \"
'\\'        # \
'\1'        # \1
'\\1'       # \1
'\141'      # \141
'\n'        # \n

# Double-quoted strings
"\'"        # '
"\""        # "
"\\"        # \
"\1"        # <U+0001>
"\\1"       # \1
"\141"      # a
"\x6d"      # m
"\x6E"      # n
"\X6d"      # X6d
"\X6E"      # X6E
"\u203d"    # ‽
"\u{62}"    # b
"\u{1f60a}" # 😊 <Printed as \ud83d\ude0a by CodeQL>
"\a"        # <bell U+0007>
"\b"        # <backspace U+0008>
"\t"        # <tab U+0009>
"\n"        # <newline U+000A>
"\v"        # <vertical tab U+000B>
"\f"        # <form feed U+000C>
"\r"        # <carriage return U+000D>
"\e"        # <escape U+001B>
"\s"        # <space U+0020>
"\c?"       # <delete U+007F> problem: only \c is parsed as part of the escape sequence
"\C-?"      # <delete U+007F> problem: only \C is parsed as part of the escape sequence

# TODO: support/test more control characters: \M-..., \cx, \C-x, etc.

# String interpolation
a = "\\." # \.
"#{a}"    # \.

# Regexps - escape sequences are handled by the regex parser, so their constant
# value should be interpreted literally and not unescaped as in double-quoted strings
/\n/
/\p/
/\u0061/

# Regexp interpolation
a = "\\." # \.
b = /\./
/#{a}#{b}/  # equivalent to /\.\./

# String arrays
%w[foo \n bar] # should be equivalent to ["foo", "\\n", "bar"], but currently misparsed as ["foo \\n", "bar"]

# Single-quoted symbols. Comments indicate the expected, unescaped string contents.
:'\''    # '
:'\"'    # \"
:'\\'    # \
:'\1'    # \1
:'\\1'   # \1
:'\141'  # \141
:'\n'    # \n

# Double-quoted symbols. Comments indicate the expected, unescaped string contents.
:"\'"        # '
:"\""        # "
:"\\"        # \
:"\1"        # <U+0001>
:"\\1"       # \1
:"\141"      # a
:"\x6d"      # m
:"\x6E"      # n
:"\X6d"      # X6d
:"\X6E"      # X6E
:"\u203d"    # ‽
:"\u{62}"    # b
:"\u{1f60a}" # 😊 <Printed as \ud83d\ude0a by CodeQL>
:"\a"        # <bell U+0007>
:"\b"        # <backspace U+0008>
:"\t"        # <tab U+0009>
:"\n"        # <newline U+000A>
:"\v"        # <vertical tab U+000B>
:"\f"        # <form feed U+000C>
:"\r"        # <carriage return U+000D>
:"\e"        # <escape U+001B>
:"\s"        # <space U+0020>
:"\c?"       # <delete U+007F> problem: only \c is parsed as part of the escape sequence
:"\C-?"      # <delete U+007F> problem: only \C is parsed as part of the escape sequence
