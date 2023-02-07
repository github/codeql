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

# GOOD
good44 = re.compile(r'("[^"]*?"|[^"\s]+)+(?=\s*|\s*$)')

# BAD
bad88 = re.compile(r'/("[^"]*?"|[^"\s]+)+(?=\s*|\s*$)X')
bad89 = re.compile(r'/("[^"]*?"|[^"\s]+)+(?=X)')

# BAD
bad90 = re.compile(r'\A(\d|0)*x')
bad91 = re.compile(r'(\d|0)*\Z')
bad92 = re.compile(r'\b(\d|0)*x')

# GOOD
stress1 = re.compile(r"(?<!&)#(\w+|(?:[\xA9\xAE\u203C\u2049\u2122\u2139\u2194-\u2199\u21A9\u21AA\u231A\u231B\u2328\u2388\u23CF\u23E9-\u23F3\u23F8-\u23FA\u24C2\u25AA\u25AB\u25B6\u25C0\u25FB-\u25FE\u2600-\u2604\u260E\u2611\u2614\u2615\u2618\u261D\u2620\u2622\u2623\u2626\u262A\u262E\u262F\u2638-\u263A\u2648-\u2653\u2660\u2663\u2665\u2666\u2668\u267B\u267F\u2692-\u2694\u2696\u2697\u2699\u269B\u269C\u26A0\u26A1\u26AA\u26AB\u26B0\u26B1\u26BD\u26BE\u26C4\u26C5\u26C8\u26CE\u26CF\u26D1\u26D3\u26D4\u26E9\u26EA\u26F0-\u26F5\u26F7-\u26FA\u26FD\u2702\u2705\u2708-\u270D\u270F\u2712\u2714\u2716\u271D\u2721\u2728\u2733\u2734\u2744\u2747\u274C\u274E\u2753-\u2755\u2757\u2763\u2764\u2795-\u2797\u27A1\u27B0\u27BF\u2934\u2935\u2B05-\u2B07\u2B1B\u2B1C\u2B50\u2B55\u3030\u303D\u3297\u3299]|\uD83C[\uDC04\uDCCF\uDD70\uDD71\uDD7E\uDD7F\uDD8E\uDD91-\uDD9A\uDE01\uDE02\uDE1A\uDE2F\uDE32-\uDE3A\uDE50\uDE51\uDF00-\uDF21\uDF24-\uDF93\uDF96\uDF97\uDF99-\uDF9B\uDF9E-\uDFF0\uDFF3-\uDFF5\uDFF7-\uDFFF]|\uD83D[\uDC00-\uDCFD\uDCFF-\uDD3D\uDD49-\uDD4E\uDD50-\uDD67\uDD6F\uDD70\uDD73-\uDD79\uDD87\uDD8A-\uDD8D\uDD90\uDD95\uDD96\uDDA5\uDDA8\uDDB1\uDDB2\uDDBC\uDDC2-\uDDC4\uDDD1-\uDDD3\uDDDC-\uDDDE\uDDE1\uDDE3\uDDEF\uDDF3\uDDFA-\uDE4F\uDE80-\uDEC5\uDECB-\uDED0\uDEE0-\uDEE5\uDEE9\uDEEB\uDEEC\uDEF0\uDEF3]|\uD83E[\uDD10-\uDD18\uDD80-\uDD84\uDDC0]|(?:0\u20E3|1\u20E3|2\u20E3|3\u20E3|4\u20E3|5\u20E3|6\u20E3|7\u20E3|8\u20E3|9\u20E3|#\u20E3|\\*\u20E3|\uD83C(?:\uDDE6\uD83C(?:\uDDEB|\uDDFD|\uDDF1|\uDDF8|\uDDE9|\uDDF4|\uDDEE|\uDDF6|\uDDEC|\uDDF7|\uDDF2|\uDDFC|\uDDE8|\uDDFA|\uDDF9|\uDDFF|\uDDEA)|\uDDE7\uD83C(?:\uDDF8|\uDDED|\uDDE9|\uDDE7|\uDDFE|\uDDEA|\uDDFF|\uDDEF|\uDDF2|\uDDF9|\uDDF4|\uDDE6|\uDDFC|\uDDFB|\uDDF7|\uDDF3|\uDDEC|\uDDEB|\uDDEE|\uDDF6|\uDDF1)|\uDDE8\uD83C(?:\uDDF2|\uDDE6|\uDDFB|\uDDEB|\uDDF1|\uDDF3|\uDDFD|\uDDF5|\uDDE8|\uDDF4|\uDDEC|\uDDE9|\uDDF0|\uDDF7|\uDDEE|\uDDFA|\uDDFC|\uDDFE|\uDDFF|\uDDED)|\uDDE9\uD83C(?:\uDDFF|\uDDF0|\uDDEC|\uDDEF|\uDDF2|\uDDF4|\uDDEA)|\uDDEA\uD83C(?:\uDDE6|\uDDE8|\uDDEC|\uDDF7|\uDDEA|\uDDF9|\uDDFA|\uDDF8|\uDDED)|\uDDEB\uD83C(?:\uDDF0|\uDDF4|\uDDEF|\uDDEE|\uDDF7|\uDDF2)|\uDDEC\uD83C(?:\uDDF6|\uDDEB|\uDDE6|\uDDF2|\uDDEA|\uDDED|\uDDEE|\uDDF7|\uDDF1|\uDDE9|\uDDF5|\uDDFA|\uDDF9|\uDDEC|\uDDF3|\uDDFC|\uDDFE|\uDDF8|\uDDE7)|\uDDED\uD83C(?:\uDDF7|\uDDF9|\uDDF2|\uDDF3|\uDDF0|\uDDFA)|\uDDEE\uD83C(?:\uDDF4|\uDDE8|\uDDF8|\uDDF3|\uDDE9|\uDDF7|\uDDF6|\uDDEA|\uDDF2|\uDDF1|\uDDF9)|\uDDEF\uD83C(?:\uDDF2|\uDDF5|\uDDEA|\uDDF4)|\uDDF0\uD83C(?:\uDDED|\uDDFE|\uDDF2|\uDDFF|\uDDEA|\uDDEE|\uDDFC|\uDDEC|\uDDF5|\uDDF7|\uDDF3)|\uDDF1\uD83C(?:\uDDE6|\uDDFB|\uDDE7|\uDDF8|\uDDF7|\uDDFE|\uDDEE|\uDDF9|\uDDFA|\uDDF0|\uDDE8)|\uDDF2\uD83C(?:\uDDF4|\uDDF0|\uDDEC|\uDDFC|\uDDFE|\uDDFB|\uDDF1|\uDDF9|\uDDED|\uDDF6|\uDDF7|\uDDFA|\uDDFD|\uDDE9|\uDDE8|\uDDF3|\uDDEA|\uDDF8|\uDDE6|\uDDFF|\uDDF2|\uDDF5|\uDDEB)|\uDDF3\uD83C(?:\uDDE6|\uDDF7|\uDDF5|\uDDF1|\uDDE8|\uDDFF|\uDDEE|\uDDEA|\uDDEC|\uDDFA|\uDDEB|\uDDF4)|\uDDF4\uD83C\uDDF2|\uDDF5\uD83C(?:\uDDEB|\uDDF0|\uDDFC|\uDDF8|\uDDE6|\uDDEC|\uDDFE|\uDDEA|\uDDED|\uDDF3|\uDDF1|\uDDF9|\uDDF7|\uDDF2)|\uDDF6\uD83C\uDDE6|\uDDF7\uD83C(?:\uDDEA|\uDDF4|\uDDFA|\uDDFC|\uDDF8)|\uDDF8\uD83C(?:\uDDFB|\uDDF2|\uDDF9|\uDDE6|\uDDF3|\uDDE8|\uDDF1|\uDDEC|\uDDFD|\uDDF0|\uDDEE|\uDDE7|\uDDF4|\uDDF8|\uDDED|\uDDE9|\uDDF7|\uDDEF|\uDDFF|\uDDEA|\uDDFE)|\uDDF9\uD83C(?:\uDDE9|\uDDEB|\uDDFC|\uDDEF|\uDDFF|\uDDED|\uDDF1|\uDDEC|\uDDF0|\uDDF4|\uDDF9|\uDDE6|\uDDF3|\uDDF7|\uDDF2|\uDDE8|\uDDFB)|\uDDFA\uD83C(?:\uDDEC|\uDDE6|\uDDF8|\uDDFE|\uDDF2|\uDDFF)|\uDDFB\uD83C(?:\uDDEC|\uDDE8|\uDDEE|\uDDFA|\uDDE6|\uDDEA|\uDDF3)|\uDDFC\uD83C(?:\uDDF8|\uDDEB)|\uDDFD\uD83C\uDDF0|\uDDFE\uD83C(?:\uDDF9|\uDDEA)|\uDDFF\uD83C(?:\uDDE6|\uDDF2|\uDDFC))))[\ufe00-\ufe0f\u200d]?)+")

MY_REG = r'X(\u0061|a)*Y'
def matcher(name): 
    re.match(MY_REG, name)