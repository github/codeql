import re

# linear
# https://github.com/github/codeql-python-CVE-coverage/issues/439
rex_blame = re.compile(r'\s*(\d+)\s*(\S+) (.*)')

# https://github.com/github/codeql-python-CVE-coverage/issues/402
whitespace = br"[\000\011\012\014\015\040]"
whitespace_optional = whitespace + b"*"
newline_only = br"[\r\n]+"
newline = whitespace_optional + newline_only + whitespace_optional
toFlag = re.compile(newline)

# https://github.com/github/codeql-python-CVE-coverage/issues/400
re.compile(r'[+-]?(\d+)*\.\d+%?')
re.compile(r'"""\s+(?:.|\n)*?\s+"""')
re.compile(r'(\{\s+)(\S+)(\s+[^}]+\s+\}\s)')
re.compile(r'".*``.*``.*"')
re.compile(r'(\s*)(?:(.+)(\s*)(=)(\s*))?(.+)(\()(.*)(\))(\s*)')
re.compile(r'(%config)(\s*\(\s*)(\w+)(\s*=\s*)(.*?)(\s*\)\s*)')
re.compile(r'(%new)(\s*)(\()(\s*.*?\s*)(\))')
re.compile(r'(\$)(evoque|overlay)(\{(%)?)(\s*[#\w\-"\'.]+[^=,%}]+?)?')
re.compile(r'(\.\w+\b)(\s*=\s*)([^;]*)(\s*;)')

# linear
# https://github.com/github/codeql-python-CVE-coverage/issues/392
simple_email_re = re.compile(r"^\S+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9._-]+$")

# https://github.com/github/codeql-python-CVE-coverage/issues/249
rx = re.compile('(?:.*,)*[ \t]*([^ \t]+)[ \t]+'
                     'realm=(["\']?)([^"\']*)\\2', re.I)

# https://github.com/github/codeql-python-CVE-coverage/issues/248
gauntlet = re.compile(
            r"""^([-/:,#%.'"\s!\w]|\w-\w|'[\s\w]+'\s*|"[\s\w]+"|\([\d,%\.\s]+\))*$""",
            flags=re.U
        )

# https://github.com/github/codeql-python-CVE-coverage/issues/227
# from .compat import tobytes

WS = "[ \t]"
OWS = WS + "{0,}?"

# RFC 7230 Section 3.2.6 "Field Value Components":
# tchar          = "!" / "#" / "$" / "%" / "&" / "'" / "*"
#                / "+" / "-" / "." / "^" / "_" / "`" / "|" / "~"
#                / DIGIT / ALPHA
# obs-text      = %x80-FF
TCHAR = r"[!#$%&'*+\-.^_`|~0-9A-Za-z]"
OBS_TEXT = r"\x80-\xff"
TOKEN = TCHAR + "{1,}"
# RFC 5234 Appendix B.1 "Core Rules":
# VCHAR         =  %x21-7E
#                  ; visible (printing) characters
VCHAR = r"\x21-\x7e"
# header-field   = field-name ":" OWS field-value OWS
# field-name     = token
# field-value    = *( field-content / obs-fold )
# field-content  = field-vchar [ 1*( SP / HTAB ) field-vchar ]
# field-vchar    = VCHAR / obs-text
# Errata from: https://www.rfc-editor.org/errata_search.php?rfc=7230&eid=4189
# changes field-content to:
#
# field-content  = field-vchar [ 1*( SP / HTAB / field-vchar )
#                  field-vchar ]

FIELD_VCHAR = "[" + VCHAR + OBS_TEXT + "]"
FIELD_CONTENT = FIELD_VCHAR + "([ \t" + VCHAR + OBS_TEXT + "]+" + FIELD_VCHAR + "){,1}"
FIELD_VALUE = "(" + FIELD_CONTENT + "){0,}"

HEADER_FIELD = re.compile(
    #  tobytes(
         "^(?P<name>" + TOKEN + "):" + OWS + "(?P<value>" + FIELD_VALUE + ")" + OWS + "$"
    #  )
 )

# https://github.com/github/codeql-python-CVE-coverage/issues/224
pattern = re.compile(
    r'^(:?(([a-zA-Z]{1})|([a-zA-Z]{1}[a-zA-Z]{1})|'  # domain pt.1
    r'([a-zA-Z]{1}[0-9]{1})|([0-9]{1}[a-zA-Z]{1})|'  # domain pt.2
    r'([a-zA-Z0-9][-_a-zA-Z0-9]{0,61}[a-zA-Z0-9]))\.)+'  # domain pt.3
    r'([a-zA-Z]{2,13}|(xn--[a-zA-Z0-9]{2,30}))$'  # TLD
)

# https://github.com/github/codeql-python-CVE-coverage/issues/189
URL_REGEX = (
     r'(?i)\b((?:[a-z][\w-]+:(?:/{1,3}|[a-z0-9%])|www\d{0,3}[.]|'
     r'[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|'
     r'(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|'
     r'[^\s`!()\[\]{};:\'".,<>?«»“”‘’]))'  # "emacs!
)

url = re.compile(URL_REGEX)
