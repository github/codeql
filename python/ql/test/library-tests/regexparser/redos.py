# This is currently a copy of the redos test-file, since that one contains many regexes.

import re

# NOT GOOD; attack: "_" + "__".repeat(100)
# Adapted from marked (https://github.com/markedjs/marked), which is licensed
# under the MIT license; see file marked-LICENSE.
bad1 = re.compile(r'''^\b_((?:__|[\s\S])+?)_\b|^\*((?:\*\*|[\s\S])+?)\*(?!\*)''')

# GOOD
# Adapted from marked (https://github.com/markedjs/marked), which is licensed
# under the MIT license; see file marked-LICENSE.
good1 = re.compile(r'^\b_((?:__|[^_])+?)_\b|^\*((?:\*\*|[^*])+?)\*(?!\*)')

# GOOD - there is no witness in the end that could cause the regexp to not match
# Adapted from brace-expansion (https://github.com/juliangruber/brace-expansion),
# which is licensed under the MIT license; see file brace-expansion-LICENSE.
good2 = re.compile(r'(.*,)+.+')

# NOT GOOD; attack: " '" + "\\\\".repeat(100)
# Adapted from CodeMirror (https://github.com/codemirror/codemirror),
# which is licensed under the MIT license; see file CodeMirror-LICENSE.
bad2 = re.compile(r'''^(?:\s+(?:"(?:[^"\\]|\\\\|\\.)+"|'(?:[^'\\]|\\\\|\\.)+'|\((?:[^)\\]|\\\\|\\.)+\)))?''')

# GOOD
# Adapted from lulucms2 (https://github.com/yiifans/lulucms2).
good2 = re.compile(r'''\(\*(?:[\s\S]*?\(\*[\s\S]*?\*\))*[\s\S]*?\*\)''')

# GOOD
# Adapted from jest (https://github.com/facebook/jest), which is licensed
# under the MIT license; see file jest-LICENSE.
good3 = re.compile(r'''^ *(\S.*\|.*)\n *([-:]+ *\|[-| :]*)\n((?:.*\|.*(?:\n|$))*)\n*''')

# NOT GOOD, variant of good3; attack: "a|\n:|\n" + "||\n".repeat(100)
bad4 = re.compile(r'''^ *(\S.*\|.*)\n *([-:]+ *\|[-| :]*)\n((?:.*\|.*(?:\n|$))*)a''')

# NOT GOOD; attack: "/" + "\\/a".repeat(100)
# Adapted from ANodeBlog (https://github.com/gefangshuai/ANodeBlog),
# which is licensed under the Apache License 2.0; see file ANodeBlog-LICENSE.
bad5 = re.compile(r'''\/(?![ *])(\\\/|.)*?\/[gim]*(?=\W|$)''')

# NOT GOOD; attack: "##".repeat(100) + "\na"
# Adapted from CodeMirror (https://github.com/codemirror/codemirror),
# which is licensed under the MIT license; see file CodeMirror-LICENSE.
bad6 = re.compile(r'''^([\s\[\{\(]|#.*)*$''')

# GOOD
good4 = re.compile(r'''(\r\n|\r|\n)+''')

# BAD - PoC: `node -e "/((?:[^\"\']|\".*?\"|\'.*?\')*?)([(,)]|$)/.test(\"'''''''''''''''''''''''''''''''''''''''''''''\\\"\");"`. It's complicated though, because the regexp still matches something, it just matches the empty-string after the attack string.
actuallyBad = re.compile(r'''((?:[^"']|".*?"|'.*?')*?)([(,)]|$)''')

# NOT GOOD; attack: "a" + "[]".repeat(100) + ".b\n"
# Adapted from Knockout (https://github.com/knockout/knockout), which is
# licensed under the MIT license; see file knockout-LICENSE
bad6 = re.compile(r'''^[\_$a-z][\_$a-z0-9]*(\[.*?\])*(\.[\_$a-z][\_$a-z0-9]*(\[.*?\])*)*$''')

# GOOD
good6 = re.compile(r'''(a|.)*''')

# Testing the NFA - only some of the below are detected.
bad7 = re.compile(r'''^([a-z]+)+$''')
bad8 = re.compile(r'''^([a-z]*)*$''')
bad9 = re.compile(r'''^([a-zA-Z0-9])(([\\-.]|[_]+)?([a-zA-Z0-9]+))*(@){1}[a-z0-9]+[.]{1}(([a-z]{2,3})|([a-z]{2,3}[.]{1}[a-z]{2,3}))$''')
bad10 = re.compile(r'''^(([a-z])+.)+[A-Z]([a-z])+$''')

# NOT GOOD; attack: "[" + "][".repeat(100) + "]!"
# Adapted from Prototype.js (https://github.com/prototypejs/prototype), which
# is licensed under the MIT license; see file Prototype.js-LICENSE.
bad11 = re.compile(r'''(([\w#:.~>+()\s-]+|\*|\[.*?\])+)\s*(,|$)''')

# NOT GOOD; attack: "'" + "\\a".repeat(100) + '"'
# Adapted from Prism (https://github.com/PrismJS/prism), which is licensed
# under the MIT license; see file Prism-LICENSE.
bad12 = re.compile(r'''("|')(\\?.)*?\1''')

# NOT GOOD
bad13 = re.compile(r'''(b|a?b)*c''')

# NOT GOOD
bad15 = re.compile(r'''(a|aa?)*b''')

# GOOD
good7 = re.compile(r'''(.|\n)*!''')

# NOT GOOD; attack: "\n".repeat(100) + "."
bad16 = re.compile(r'''(.|\n)*!''')

# GOOD
good8 = re.compile(r'''([\w.]+)*''')

# NOT GOOD
bad17 = re.compile(r'''(a|aa?)*b''')

# GOOD - not used as regexp
good9 = '(a|aa?)*b'

# NOT GOOD
bad18 = re.compile(r'''(([\s\S]|[^a])*)"''')

# GOOD - there is no witness in the end that could cause the regexp to not match
good10 = re.compile(r'''([^"']+)*''')

# NOT GOOD
bad20 = re.compile(r'''((.|[^a])*)"''')

# GOOD
good10 = re.compile(r'''((a|[^a])*)"''')

# NOT GOOD
bad21 = re.compile(r'''((b|[^a])*)"''')

# NOT GOOD
bad22 = re.compile(r'''((G|[^a])*)"''')

# NOT GOOD
bad23 = re.compile(r'''(([0-9]|[^a])*)"''')

# NOT GOOD
bad24 = re.compile(r'''(?:=(?:([!#\$%&'\*\+\-\.\^_`\|~0-9A-Za-z]+)|"((?:\\[\x00-\x7f]|[^\x00-\x08\x0a-\x1f\x7f"])*)"))?''')

# NOT GOOD
bad25 = re.compile(r'''"((?:\\[\x00-\x7f]|[^\x00-\x08\x0a-\x1f\x7f"])*)"''')

# GOOD
bad26 = re.compile(r'''"((?:\\[\x00-\x7f]|[^\x00-\x08\x0a-\x1f\x7f"\\])*)"''')

# NOT GOOD
bad27 = re.compile(r'''(([a-z]|[d-h])*)"''')

# NOT GOOD
bad27 = re.compile(r'''(([^a-z]|[^0-9])*)"''')

# NOT GOOD
bad28 = re.compile(r'''((\d|[0-9])*)"''')

# NOT GOOD
bad29 = re.compile(r'''((\s|\s)*)"''')

# NOT GOOD
bad30 = re.compile(r'''((\w|G)*)"''')

# GOOD
good11 = re.compile(r'''((\s|\d)*)"''')

# NOT GOOD
bad31 = re.compile(r'''((\d|\w)*)"''')

# NOT GOOD
bad32 = re.compile(r'''((\d|5)*)"''')

# NOT GOOD
bad33 = re.compile(r'''((\s|[\f])*)"''')

# NOT GOOD
bad34 = re.compile(r'''((\s|[\v]|\\v)*)"''')

# NOT GOOD
bad35 = re.compile(r'''((\f|[\f])*)"''')

# NOT GOOD
bad36 = re.compile(r'''((\W|\D)*)"''')

# NOT GOOD
bad37 = re.compile(r'''((\S|\w)*)"''')

# NOT GOOD
bad38 = re.compile(r'''((\S|[\w])*)"''')

# NOT GOOD
bad39 = re.compile(r'''((1s|[\da-z])*)"''')

# NOT GOOD
bad40 = re.compile(r'''((0|[\d])*)"''')

# NOT GOOD
bad41 = re.compile(r'''(([\d]+)*)"''')

# GOOD - there is no witness in the end that could cause the regexp to not match
good12 = re.compile(r'''(\d+(X\d+)?)+''')

# GOOD - there is no witness in the end that could cause the regexp to not match
good13 = re.compile(r'''([0-9]+(X[0-9]*)?)*''')

# GOOD
good15 = re.compile(r'''^([^>]+)*(>|$)''')

# NOT GOOD
bad43 = re.compile(r'''^([^>a]+)*(>|$)''')

# NOT GOOD
bad44 = re.compile(r'''(\n\s*)+$''')

# NOT GOOD
bad45 = re.compile(r'''^(?:\s+|#.*|\(\?#[^)]*\))*(?:[?*+]|{\d+(?:,\d*)?})''')

# NOT GOOD
bad46 = re.compile(r'''\{\[\s*([a-zA-Z]+)\(([a-zA-Z]+)\)((\s*([a-zA-Z]+)\: ?([ a-zA-Z{}]+),?)+)*\s*\]\}''')

# NOT GOOD
bad47 = re.compile(r'''(a+|b+|c+)*c''')

# NOT GOOD
bad48 = re.compile(r'''(((a+a?)*)+b+)''')

# NOT GOOD
bad49 = re.compile(r'''(a+)+bbbb''')

# GOOD
good16 = re.compile(r'''(a+)+aaaaa*a+''')

# NOT GOOD
bad50 = re.compile(r'''(a+)+aaaaa$''')

# GOOD
good17 = re.compile(r'''(\n+)+\n\n''')

# NOT GOOD
bad51 = re.compile(r'''(\n+)+\n\n$''')

# NOT GOOD
bad52 = re.compile(r'''([^X]+)*$''')

# NOT GOOD
bad53 = re.compile(r'''(([^X]b)+)*$''')

# GOOD
good18 = re.compile(r'''(([^X]b)+)*($|[^X]b)''')

# NOT GOOD
bad54 = re.compile(r'''(([^X]b)+)*($|[^X]c)''')

# GOOD
good20 = re.compile(r'''((ab)+)*ababab''')

# GOOD
good21 = re.compile(r'''((ab)+)*abab(ab)*(ab)+''')

# GOOD
good22 = re.compile(r'''((ab)+)*''')

# NOT GOOD
bad55 = re.compile(r'''((ab)+)*$''')

# GOOD
good23 = re.compile(r'''((ab)+)*[a1][b1][a2][b2][a3][b3]''')

# NOT GOOD
bad56 = re.compile(r'''([\n\s]+)*(.)''')

# GOOD - any witness passes through the accept state.
good24 = re.compile(r'''(A*A*X)*''')

# GOOD
good26 = re.compile(r'''([^\\\]]+)*''')

# NOT GOOD
bad59 = re.compile(r'''(\w*foobarbaz\w*foobarbaz\w*foobarbaz\w*foobarbaz\s*foobarbaz\d*foobarbaz\w*)+-''')

# NOT GOOD
bad60 = re.compile(r'''(.thisisagoddamnlongstringforstresstestingthequery|\sthisisagoddamnlongstringforstresstestingthequery)*-''')

# NOT GOOD
bad61 = re.compile(r'''(thisisagoddamnlongstringforstresstestingthequery|this\w+query)*-''')

# GOOD
good27 = re.compile(r'''(thisisagoddamnlongstringforstresstestingthequery|imanotherbutunrelatedstringcomparedtotheotherstring)*-''')

# GOOD (but false positive caused by the extractor converting all four unpaired surrogates to \uFFFD)
good28 = re.compile('''foo([\uDC66\uDC67]|[\uDC68\uDC69])*foo''')

# GOOD (but false positive caused by the extractor converting all four unpaired surrogates to \uFFFD)
good29 = re.compile('''foo((\uDC66|\uDC67)|(\uDC68|\uDC69))*foo''')

# NOT GOOD (but cannot currently construct a prefix)
bad62 = re.compile(r'''a{2,3}(b+)+X''')

# NOT GOOD (and a good prefix test)
bad63 = re.compile(r'''^<(\w+)((?:\s+\w+(?:\s*=\s*(?:(?:"[^"]*")|(?:'[^']*')|[^>\s]+))?)*)\s*(\/?)>''')

# GOOD
good30 = re.compile(r'''(a+)*[\s\S][\s\S][\s\S]?''')

# GOOD - but we fail to see that repeating the attack string ends in the "accept any" state (due to not parsing the range `[\s\S]{2,3}`).
good31 = re.compile(r'''(a+)*[\s\S]{2,3}''')

# GOOD - but we spuriously conclude that a rejecting suffix exists (due to not parsing the range `[\s\S]{2,}` when constructing the NFA).
good32 = re.compile(r'''(a+)*([\s\S]{2,}|X)$''')

# GOOD
good33 = re.compile(r'''(a+)*([\s\S]*|X)$''')

# NOT GOOD
bad64 = re.compile(r'''((a+)*$|[\s\S]+)''')

# GOOD - but still flagged. The only change compared to the above is the order of alternatives, which we don't model.
good34 = re.compile(r'''([\s\S]+|(a+)*$)''')

# GOOD
good35 = re.compile(r'''((;|^)a+)+$''')

# NOT GOOD (a good prefix test)
bad65 = re.compile(r'''(^|;)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(e+)+f''')

# NOT GOOD
bad66 = re.compile(r'''^ab(c+)+$''')

# NOT GOOD
bad67 = re.compile(r'''(\d(\s+)*){20}''')

# GOOD - but we spuriously conclude that a rejecting suffix exists.
good36 = re.compile(r'''(([^/]|X)+)(\/[\s\S]*)*$''')

# GOOD - but we spuriously conclude that a rejecting suffix exists.
good37 = re.compile(r'''^((x([^Y]+)?)*(Y|$))''')

# NOT GOOD
bad68 = re.compile(r'''(a*)+b''')

# NOT GOOD
bad69 = re.compile(r'''foo([\w-]*)+bar''')

# NOT GOOD
bad70 = re.compile(r'''((ab)*)+c''')

# NOT GOOD
bad71 = re.compile(r'''(a?a?)*b''')

# GOOD
good38 = re.compile(r'''(a?)*b''')

# NOT GOOD - but not detected
bad72 = re.compile(r'''(c?a?)*b''')

# NOT GOOD
bad73 = re.compile(r'''(?:a|a?)+b''')

# NOT GOOD - but not detected.
bad74 = re.compile(r'''(a?b?)*$''')

# NOT GOOD
bad76 = re.compile(r'''PRE(([a-c]|[c-d])T(e?e?e?e?|X))+(cTcT|cTXcTX$)''')

# NOT GOOD - but not detected
bad77 = re.compile(r'''^((a)+\w)+$''')

# NOT GOOD
bad78 = re.compile(r'''^(b+.)+$''')

# GOOD
good39 = re.compile(r'''a*b''')

# All 4 bad combinations of nested * and +
bad79 = re.compile(r'''(a*)*b''')
bad80 = re.compile(r'''(a+)*b''')
bad81 = re.compile(r'''(a*)+b''')
bad82 = re.compile(r'''(a+)+b''')

# GOOD
good40 = re.compile(r'''(a|b)+''')
good41 = re.compile(r'''(?:[\s;,"'<>(){}|[\]@=+*]|:(?![/\\]))+''') # parses wrongly, sees column 42 as a char set start

# NOT GOOD
bad83 = re.compile(r'''^((?:a{|-)|\w\{)+X$''')
bad84 = re.compile(r'''^((?:a{0|-)|\w\{\d)+X$''')
bad85 = re.compile(r'''^((?:a{0,|-)|\w\{\d,)+X$''')
bad86 = re.compile(r'''^((?:a{0,2|-)|\w\{\d,\d)+X$''')

# GOOD:
good42 = re.compile(r'''^((?:a{0,2}|-)|\w\{\d,\d\})+X$''')

# NOT GOOD
bad87 = re.compile(r'X(\u0061|a)*Y')

# GOOD
good43 = re.compile(r'X(\u0061|b)+Y')
