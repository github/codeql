# NOT GOOD; attack: "_" + "__".repeat(100)
# Adapted from marked (https://github.com/markedjs/marked), which is licensed
# under the MIT license; see file marked-LICENSE.
bad1 = /^\b_((?:__|[\s\S])+?)_\b|^\*((?:\*\*|[\s\S])+?)\*(?!\*)/ # $ Alert

# GOOD
# Adapted from marked (https://github.com/markedjs/marked), which is licensed
# under the MIT license; see file marked-LICENSE.
good1 = /^\b_((?:__|[^_])+?)_\b|^\*((?:\*\*|[^*])+?)\*(?!\*)/

# GOOD - there is no witness in the end that could cause the regexp to not match
# Adapted from brace-expansion (https://github.com/juliangruber/brace-expansion),
# which is licensed under the MIT license; see file brace-expansion-LICENSE.
good2 = /(.*,)+.+/

# NOT GOOD; attack: " '" + "\\\\".repeat(100)
# Adapted from CodeMirror (https://github.com/codemirror/codemirror),
# which is licensed under the MIT license; see file CodeMirror-LICENSE.
bad2 = /^(?:\s+(?:"(?:[^"\\]|\\\\|\\.)+"|'(?:[^'\\]|\\\\|\\.)+'|\((?:[^)\\]|\\\\|\\.)+\)))?/ # $ Alert

# GOOD
# Adapted from lulucms2 (https://github.com/yiifans/lulucms2).
good2 = /\(\*(?:[\s\S]*?\(\*[\s\S]*?\*\))*[\s\S]*?\*\)/

# GOOD
# Adapted from jest (https://github.com/facebook/jest), which is licensed
# under the MIT license; see file jest-LICENSE.
good3 = /^ *(\S.*\|.*)\n *([-:]+ *\|[-| :]*)\n((?:.*\|.*(?:\n|$))*)\n*/

# NOT GOOD, variant of good3; attack: "a|\n:|\n" + "||\n".repeat(100)
bad4 = /^ *(\S.*\|.*)\n *([-:]+ *\|[-| :]*)\n((?:.*\|.*(?:\n|$))*)a/ # $ Alert

# NOT GOOD; attack: "/" + "\\/a".repeat(100)
# Adapted from ANodeBlog (https://github.com/gefangshuai/ANodeBlog),
# which is licensed under the Apache License 2.0; see file ANodeBlog-LICENSE.
bad5 = /\/(?![ *])(\\\/|.)*?\/[gim]*(?=\W|$)/ # $ Alert

# NOT GOOD; attack: "##".repeat(100) + "\na"
# Adapted from CodeMirror (https://github.com/codemirror/codemirror),
# which is licensed under the MIT license; see file CodeMirror-LICENSE.
bad6 = /^([\s\[\{\(]|#.*)*$/ # $ Alert

# GOOD
good4 = /(\r\n|\r|\n)+/

# BAD - PoC: `node -e "/((?:[^\"\']|\".*?\"|\'.*?\')*?)([(,)]|$)/.test(\"'''''''''''''''''''''''''''''''''''''''''''''\\\"\");"`. It's complicated though, because the regexp still matches something, it just matches the empty-string after the attack string.
actuallyBad = /((?:[^"']|".*?"|'.*?')*?)([(,)]|$)/ # $ Alert

# NOT GOOD; attack: "a" + "[]".repeat(100) + ".b\n"
# Adapted from Knockout (https://github.com/knockout/knockout), which is
# licensed under the MIT license; see file knockout-LICENSE
bad6 = /^[\_$a-z][\_$a-z0-9]*(\[.*?\])*(\.[\_$a-z][\_$a-z0-9]*(\[.*?\])*)*$/i # $ Alert

# GOOD
good6 = /(a|.)*/

# Testing the NFA - only some of the below are detected.
bad7 = /^([a-z]+)+$/ # $ Alert
bad8 = /^([a-z]*)*$/ # $ Alert
bad9 = /^([a-zA-Z0-9])(([\\.-]|[_]+)?([a-zA-Z0-9]+))*(@){1}[a-z0-9]+[.]{1}(([a-z]{2,3})|([a-z]{2,3}[.]{1}[a-z]{2,3}))$/ # $ Alert
bad10 = /^(([a-z])+.)+[A-Z]([a-z])+$/ # $ Alert

# NOT GOOD; attack: "[" + "][".repeat(100) + "]!"
# Adapted from Prototype.js (https://github.com/prototypejs/prototype), which
# is licensed under the MIT license; see file Prototype.js-LICENSE.
bad11 = /(([\w#:.~>+()\s-]+|\*|\[.*?\])+)\s*(,|$)/ # $ Alert

# NOT GOOD; attack: "'" + "\\a".repeat(100) + '"'
# Adapted from Prism (https://github.com/PrismJS/prism), which is licensed
# under the MIT license; see file Prism-LICENSE.
bad12 = /("|')(\\?.)*?\1/ # $ Alert

# NOT GOOD
bad13 = /(b|a?b)*c/ # $ Alert

# NOT GOOD
bad15 = /(a|aa?)*b/ # $ Alert

# GOOD
good7 = /(.|\n)*!/

# NOT GOOD; attack: "\n".repeat(100) + "."
bad16 = /(.|\n)*!/m # $ Alert

# GOOD
good8 = /([\w.]+)*/

# NOT GOOD
bad17 = Regexp.new '(a|aa?)*b' # $ Alert

# GOOD - not used as regexp
good9 = '(a|aa?)*b'

# NOT GOOD
bad18 = /(([\S\s]|[^a])*)"/ # $ Alert

# GOOD - there is no witness in the end that could cause the regexp to not match
good10 = /([^"']+)*/

# NOT GOOD
bad20 = /((.|[^a])*)"/ # $ Alert

# GOOD
good10 = /((a|[^a])*)"/

# NOT GOOD
bad21 = /((b|[^a])*)"/ # $ Alert

# NOT GOOD
bad22 = /((G|[^a])*)"/ # $ Alert

# NOT GOOD
bad23 = /(([0-9]|[^a])*)"/ # $ Alert

# BAD - missing result
bad24 = /(?:=(?:([!#\$%&'\*\+\-\.\^_`\|~0-9A-Za-z]+)|"((?:\\[\x00-\x7f]|[^\x00-\x08\x0a-\x1f\x7f"])*)"))?/

# BAD - missing result
bad25 = /"((?:\\[\x00-\x7f]|[^\x00-\x08\x0a-\x1f\x7f"])*)"/

# GOOD
bad26 = /"((?:\\[\x00-\x7f]|[^\x00-\x08\x0a-\x1f\x7f"\\])*)"/

# NOT GOOD
bad27 = /(([a-z]|[d-h])*)"/ # $ Alert

# NOT GOOD
bad27 = /(([^a-z]|[^0-9])*)"/ # $ Alert

# NOT GOOD
bad28 = /((\d|[0-9])*)"/ # $ Alert

# NOT GOOD
bad29 = /((\s|\s)*)"/ # $ Alert

# NOT GOOD
bad30 = /((\w|G)*)"/ # $ Alert

# GOOD
good11 = /((\s|\d)*)"/

# NOT GOOD
bad31 = /((\d|\w)*)"/ # $ Alert

# NOT GOOD
bad32 = /((\d|5)*)"/ # $ Alert

# BAD - \f is not handled correctly
bad33 = /((\s|[\f])*)"/ # $ Alert

# BAD - \v is not handled correctly
bad34 = /((\s|[\v]|\\v)*)"/ # $ Alert

# NOT GOOD
bad35 = /((\f|[\f])*)"/ # $ Alert

# NOT GOOD
bad36 = /((\W|\D)*)"/ # $ Alert

# NOT GOOD
bad37 = /((\S|\w)*)"/ # $ Alert

# NOT GOOD
bad38 = /((\S|[\w])*)"/ # $ Alert

# NOT GOOD
bad39 = /((1s|[\da-z])*)"/ # $ Alert

# NOT GOOD
bad40 = /((0|[\d])*)"/ # $ Alert

# NOT GOOD
bad41 = /(([\d]+)*)"/ # $ Alert

# GOOD - there is no witness in the end that could cause the regexp to not match
good12 = /(\d+(X\d+)?)+/

# GOOD - there is no witness in the end that could cause the regexp to not match
good13 = /([0-9]+(X[0-9]*)?)*/

# GOOD
good15 = /^([^>]+)*(>|$)/

# NOT GOOD
bad43 = /^([^>a]+)*(>|$)/ # $ Alert

# NOT GOOD
bad44 = /(\n\s*)+$/ # $ Alert

# NOT GOOD
bad45 = /^(?:\s+|#.*|\(\?#[^)]*\))*(?:[?*+]|{\d+(?:,\d*)?})/ # $ Alert

# NOT GOOD
bad46 = /\{\[\s*([a-zA-Z]+)\(([a-zA-Z]+)\)((\s*([a-zA-Z]+)\: ?([ a-zA-Z{}]+),?)+)*\s*\]\}/ # $ Alert

# NOT GOOD
bad47 = /(a+|b+|c+)*c/ # $ Alert

# NOT GOOD
bad48 = /(((a+a?)*)+b+)/ # $ Alert

# NOT GOOD
bad49 = /(a+)+bbbb/ # $ Alert

# GOOD
good16 = /(a+)+aaaaa*a+/

# NOT GOOD
bad50 = /(a+)+aaaaa$/ # $ Alert

# GOOD
good17 = /(\n+)+\n\n/

# NOT GOOD
bad51 = /(\n+)+\n\n$/ # $ Alert

# NOT GOOD
bad52 = /([^X]+)*$/ # $ Alert

# NOT GOOD
bad53 = /(([^X]b)+)*$/ # $ Alert

# GOOD
good18 = /(([^X]b)+)*($|[^X]b)/

# NOT GOOD
bad54 = /(([^X]b)+)*($|[^X]c)/ # $ Alert

# GOOD
good20 = /((ab)+)*ababab/

# GOOD
good21 = /((ab)+)*abab(ab)*(ab)+/

# GOOD
good22 = /((ab)+)*/

# NOT GOOD
bad55 = /((ab)+)*$/ # $ Alert

# GOOD
good23 = /((ab)+)*[a1][b1][a2][b2][a3][b3]/

# NOT GOOD
bad56 = /([\n\s]+)*(.)/ # $ Alert

# GOOD - any witness passes through the accept state.
good24 = /(A*A*X)*/

# GOOD
good26 = /([^\\\]]+)*/

# NOT GOOD
bad59 = /(\w*foobarbaz\w*foobarbaz\w*foobarbaz\w*foobarbaz\s*foobarbaz\d*foobarbaz\w*)+-/ # $ Alert

# NOT GOOD
bad60 = /(.thisisagoddamnlongstringforstresstestingthequery|\sthisisagoddamnlongstringforstresstestingthequery)*-/ # $ Alert

# NOT GOOD
bad61 = /(thisisagoddamnlongstringforstresstestingthequery|this\w+query)*-/ # $ Alert

# GOOD
good27 = /(thisisagoddamnlongstringforstresstestingthequery|imanotherbutunrelatedstringcomparedtotheotherstring)*-/

# GOOD
#good28 = /foo([\uDC66\uDC67]|[\uDC68\uDC69])*foo/

# GOOD
#good29 = /foo((\uDC66|\uDC67)|(\uDC68|\uDC69))*foo/

# NOT GOOD (but cannot currently construct a prefix)
bad62 = /a{2,3}(b+)+X/ # $ Alert

# NOT GOOD (and a good prefix test)
bad63 = /^<(\w+)((?:\s+\w+(?:\s*=\s*(?:(?:"[^"]*")|(?:'[^']*')|[^>\s]+))?)*)\s*(\/?)>/ # $ Alert

# GOOD
good30 = /(a+)*[\S\s][\S\s][\S\s]?/

# GOOD - but we fail to see that repeating the attack string ends in the "accept any" state (due to not parsing the range `[^]{2,3}`).
good31 = /(a+)*[\S\s]{2,3}/ # $ Alert

# GOOD - but we spuriously conclude that a rejecting suffix exists (due to not parsing the range `[^]{2,}` when constructing the NFA).
good32 = /(a+)*([\S\s]{2,}|X)$/ # $ Alert

# GOOD
good33 = /(a+)*([\S\s]*|X)$/

# NOT GOOD
bad64 = /((a+)*$|[\S\s]+)/ # $ Alert

# GOOD - but still flagged. The only change compared to the above is the order of alternatives, which we don't model.
good34 = /([\S\s]+|(a+)*$)/ # $ Alert

# GOOD
good35 = /((;|^)a+)+$/

# NOT GOOD (a good prefix test)
bad65 = /(^|;)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(e+)+f/ # $ Alert

# NOT GOOD
bad66 = /^ab(c+)+$/ # $ Alert

# NOT GOOD
bad67 = /(\d(\s+)*){20}/ # $ Alert

# GOOD - but we spuriously conclude that a rejecting suffix exists.
good36 = /(([^\/]|X)+)(\/[\S\s]*)*$/ # $ Alert

# GOOD - but we spuriously conclude that a rejecting suffix exists.
good37 = /^((x([^Y]+)?)*(Y|$))/ # $ Alert

# NOT GOOD
bad68 = /(a*)+b/ # $ Alert

# NOT GOOD
bad69 = /foo([\w-]*)+bar/ # $ Alert

# NOT GOOD
bad70 = /((ab)*)+c/ # $ Alert

# NOT GOOD
bad71 = /(a?a?)*b/ # $ Alert

# GOOD
good38 = /(a?)*b/

# NOT GOOD - but not detected
bad72 = /(c?a?)*b/ # $ MISSING: Alert

# NOT GOOD
bad73 = /(?:a|a?)+b/ # $ Alert

# NOT GOOD - but not detected.
bad74 = /(a?b?)*$/ # $ MISSING: Alert

# NOT GOOD
bad76 = /PRE(([a-c]|[c-d])T(e?e?e?e?|X))+(cTcT|cTXcTX$)/ # $ Alert

# NOT GOOD
bad77 = /^((a)+\w)+$/ # $ Alert

# NOT GOOD
bad78 = /^(b+.)+$/ # $ Alert

# GOOD
good39 = /a*b/

# All 4 bad combinations of nested * and +
bad79 = /(a*)*b/ # $ Alert
bad80 = /(a+)*b/ # $ Alert
bad81 = /(a*)+b/ # $ Alert
bad82 = /(a+)+b/ # $ Alert

# GOOD
good40 = /(a|b)+/
good41 = /(?:[\s;,"'<>(){}|\[\]@=+*]|:(?![\/\\]))+/

# NOT GOOD
bad83 = /^((?:a{|-)|\w\{)+X$/ # $ Alert
bad84 = /^((?:a{0|-)|\w\{\d)+X$/ # $ Alert
bad85 = /^((?:a{0,|-)|\w\{\d,)+X$/ # $ Alert
bad86 = /^((?:a{0,2|-)|\w\{\d,\d)+X$/ # $ Alert

# NOT GOOD
bad87 = /^((?:a{0,2}|-)|\w\{\d,\d\})+X$/

# NOT GOOD
bad88 = /^X(\u0061|a)*Y$/ # $ Alert

# GOOD
good43 = /^X(\u0061|b)+Y$/

# NOT GOOD
bad88 = /X([[:digit:]]|\d)+Y/ # $ Alert

# NOT GOOD
bad89 = /\G(a|\w)*$/ # $ Alert
bad90 = /\b(a|\w)*$/ # $ Alert

# NOT GOOD; attack: "0".repeat(30) + "!"
# Adapated from addressable (https://github.com/sporkmonger/addressable)
# which is licensed under the Apache License 2.0; see file addressable-LICENSE.
module Bad91
  ALPHA = "a-zA-Z"
  DIGIT = "0-9"
  var_char_class = ALPHA + DIGIT + '_'
  var_char = "(?:(?:[#{var_char_class}]|%[a-fA-F0-9][a-fA-F0-9])+)"
  var = "(?:#{var_char}(?:\\.?#{var_char})*)"
  bad91 = /^#{var}$/ # $ Alert
end
