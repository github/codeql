// Adapted from marked (https://github.com/markedjs/marked), which is licensed
// under the MIT license; see file marked-LICENSE.
var bad1 = /^\b_((?:__|[\s\S])+?)_\b|^\*((?:\*\*|[\s\S])+?)\*(?!\*)/; // $ Alert[js/redos] - attack: "_" + "__".repeat(100)


// Adapted from marked (https://github.com/markedjs/marked), which is licensed
// under the MIT license; see file marked-LICENSE.
var good1 = /^\b_((?:__|[^_])+?)_\b|^\*((?:\*\*|[^*])+?)\*(?!\*)/;

// OK - there is no witness in the end that could cause the regexp to not match
// Adapted from brace-expansion (https://github.com/juliangruber/brace-expansion),
// which is licensed under the MIT license; see file brace-expansion-LICENSE.
var good2 = /(.*,)+.+/;

// Adapted from CodeMirror (https://github.com/codemirror/codemirror),
// which is licensed under the MIT license; see file CodeMirror-LICENSE.
var bad2 = /^(?:\s+(?:"(?:[^"\\]|\\\\|\\.)+"|'(?:[^'\\]|\\\\|\\.)+'|\((?:[^)\\]|\\\\|\\.)+\)))?/; // $ Alert[js/redos] - attack: " '" + "\\\\".repeat(100)


// Adapted from lulucms2 (https://github.com/yiifans/lulucms2).
var good2 = /\(\*(?:[\s\S]*?\(\*[\s\S]*?\*\))*[\s\S]*?\*\)/;


// Adapted from jest (https://github.com/facebook/jest), which is licensed
// under the MIT license; see file jest-LICENSE.
var good3 = /^ *(\S.*\|.*)\n *([-:]+ *\|[-| :]*)\n((?:.*\|.*(?:\n|$))*)\n*/;

var bad4 = /^ *(\S.*\|.*)\n *([-:]+ *\|[-| :]*)\n((?:.*\|.*(?:\n|$))*)a/; // $ Alert[js/redos] - variant of good3; attack: "a|\n:|\n" + "||\n".repeat(100)

// Adapted from ANodeBlog (https://github.com/gefangshuai/ANodeBlog),
// which is licensed under the Apache License 2.0; see file ANodeBlog-LICENSE.
var bad5 = /\/(?![ *])(\\\/|.)*?\/[gim]*(?=\W|$)/; // $ Alert[js/redos] - attack: "/" + "\\/a".repeat(100)

// Adapted from CodeMirror (https://github.com/codemirror/codemirror),
// which is licensed under the MIT license; see file CodeMirror-LICENSE.
var bad6 = /^([\s\[\{\(]|#.*)*$/; // $ Alert[js/redos] - attack: "##".repeat(100) + "\na"


var good4 = /(\r\n|\r|\n)+/;

// BAD - PoC: `node -e "/((?:[^\"\']|\".*?\"|\'.*?\')*?)([(,)]|$)/.test(\"'''''''''''''''''''''''''''''''''''''''''''''\\\"\");"`. It's complicated though, because the regexp still matches something, it just matches the empty-string after the attack string.
var actuallyBad = /((?:[^"']|".*?"|'.*?')*?)([(,)]|$)/; // $ Alert[js/redos]

// Adapted from Knockout (https://github.com/knockout/knockout), which is
// licensed under the MIT license; see file knockout-LICENSE
var bad6 = /^[\_$a-z][\_$a-z0-9]*(\[.*?\])*(\.[\_$a-z][\_$a-z0-9]*(\[.*?\])*)*$/i; // $ Alert[js/redos] - attack: "a" + "[]".repeat(100) + ".b\n"


var good6 = /(a|.)*/;

// Testing the NFA - only some of the below are detected.
var bad7 = /^([a-z]+)+$/; // $ Alert[js/redos]
var bad8 = /^([a-z]*)*$/; // $ Alert[js/redos]
var bad9 = /^([a-zA-Z0-9])(([\\-.]|[_]+)?([a-zA-Z0-9]+))*(@){1}[a-z0-9]+[.]{1}(([a-z]{2,3})|([a-z]{2,3}[.]{1}[a-z]{2,3}))$/; // $ Alert[js/redos]
var bad10 = /^(([a-z])+.)+[A-Z]([a-z])+$/; // $ Alert[js/redos]

// Adapted from Prototype.js (https://github.com/prototypejs/prototype), which
// is licensed under the MIT license; see file Prototype.js-LICENSE.
var bad11 = /(([\w#:.~>+()\s-]+|\*|\[.*?\])+)\s*(,|$)/; // $ Alert[js/redos] - attack: "[" + "][".repeat(100) + "]!"

// Adapted from Prism (https://github.com/PrismJS/prism), which is licensed
// under the MIT license; see file Prism-LICENSE.
var bad12 = /("|')(\\?.)*?\1/g; // $ Alert[js/redos] - attack: "'" + "\\a".repeat(100) + '"'

var bad13 = /(b|a?b)*c/; // $ Alert[js/redos]

var bad15 = /(a|aa?)*b/; // $ Alert[js/redos]


var good7 = /(.|\n)*!/;

var bad16 = /(.|\n)*!/s; // $ Alert[js/redos] - attack: "\n".repeat(100) + "."


var good8 = /([\w.]+)*/;

var bad17 = new RegExp('(a|aa?)*b'); // $ Alert[js/redos]

// OK - not used as regexp
var good9 = '(a|aa?)*b';

var bad18 = /(([^]|[^a])*)"/; // $ Alert[js/redos]

// OK - there is no witness in the end that could cause the regexp to not match
var good10 = /([^"']+)*/g;

var bad20 = /((.|[^a])*)"/; // $ Alert[js/redos]


var good10 = /((a|[^a])*)"/;

var bad21 = /((b|[^a])*)"/; // $ Alert[js/redos]

var bad22 = /((G|[^a])*)"/; // $ Alert[js/redos]

var bad23 = /(([0-9]|[^a])*)"/; // $ Alert[js/redos]

var bad24 = /(?:=(?:([!#\$%&'\*\+\-\.\^_`\|~0-9A-Za-z]+)|"((?:\\[\x00-\x7f]|[^\x00-\x08\x0a-\x1f\x7f"])*)"))?/; // $ Alert[js/redos]

var bad25 = /"((?:\\[\x00-\x7f]|[^\x00-\x08\x0a-\x1f\x7f"])*)"/; // $ Alert[js/redos]


var fix25 = /"((?:\\[\x00-\x7f]|[^\x00-\x08\x0a-\x1f\x7f"\\])*)"/; // OK - fixed version of bad25

var bad27 = /(([a-z]|[d-h])*)"/; // $ Alert[js/redos]

var bad27 = /(([^a-z]|[^0-9])*)"/; // $ Alert[js/redos]

var bad28 = /((\d|[0-9])*)"/; // $ Alert[js/redos]

var bad29 = /((\s|\s)*)"/; // $ Alert[js/redos]

var bad30 = /((\w|G)*)"/; // $ Alert[js/redos]


var good11 = /((\s|\d)*)"/;

var bad31 = /((\d|\w)*)"/; // $ Alert[js/redos]

var bad32 = /((\d|5)*)"/; // $ Alert[js/redos]

var bad33 = /((\s|[\f])*)"/; // $ Alert[js/redos]

var bad34 = /((\s|[\v]|\\v)*)"/; // $ Alert[js/redos]

var bad35 = /((\f|[\f])*)"/; // $ Alert[js/redos]

var bad36 = /((\W|\D)*)"/; // $ Alert[js/redos]

var bad37 = /((\S|\w)*)"/; // $ Alert[js/redos]

var bad38 = /((\S|[\w])*)"/; // $ Alert[js/redos]

var bad39 = /((1s|[\da-z])*)"/; // $ Alert[js/redos]

var bad40 = /((0|[\d])*)"/; // $ Alert[js/redos]

var bad41 = /(([\d]+)*)"/; // $ Alert[js/redos]

// OK - there is no witness in the end that could cause the regexp to not match
var good12 = /(\d+(X\d+)?)+/;

// OK - there is no witness in the end that could cause the regexp to not match
var good13 = /([0-9]+(X[0-9]*)?)*/;


var good15 = /^([^>]+)*(>|$)/;

var bad43 = /^([^>a]+)*(>|$)/; // $ Alert[js/redos]

var bad44 = /(\n\s*)+$/; // $ Alert[js/redos]

var bad45 = /^(?:\s+|#.*|\(\?#[^)]*\))*(?:[?*+]|{\d+(?:,\d*)?})/; // $ Alert[js/redos]

var bad46 = /\{\[\s*([a-zA-Z]+)\(([a-zA-Z]+)\)((\s*([a-zA-Z]+)\: ?([ a-zA-Z{}]+),?)+)*\s*\]\}/; // $ Alert[js/redos]

var bad47 = /(a+|b+|c+)*c/; // $ Alert[js/redos]

var bad48 = /(((a+a?)*)+b+)/; // $ Alert[js/redos]

var bad49 = /(a+)+bbbb/; // $ Alert[js/redos]


var good16 = /(a+)+aaaaa*a+/;

var bad50 = /(a+)+aaaaa$/; // $ Alert[js/redos]


var good17 = /(\n+)+\n\n/;

var bad51 = /(\n+)+\n\n$/; // $ Alert[js/redos]

var bad52 = /([^X]+)*$/; // $ Alert[js/redos]

var bad53 = /(([^X]b)+)*$/; // $ Alert[js/redos]


var good18 = /(([^X]b)+)*($|[^X]b)/;

var bad54 = /(([^X]b)+)*($|[^X]c)/; // $ Alert[js/redos]


var good20 = /((ab)+)*ababab/;


var good21 = /((ab)+)*abab(ab)*(ab)+/;


var good22 = /((ab)+)*/;

var bad55 = /((ab)+)*$/; // $ Alert[js/redos]


var good23 = /((ab)+)*[a1][b1][a2][b2][a3][b3]/;

var bad56 = /([\n\s]+)*(.)/; // $ Alert[js/redos]

// OK - any witness passes through the accept state.
var good24 = /(A*A*X)*/;


var good26 = /([^\\\]]+)*/

var bad59 = /(\w*foobarbaz\w*foobarbaz\w*foobarbaz\w*foobarbaz\s*foobarbaz\d*foobarbaz\w*)+-/; // $ Alert[js/redos]

var bad60 = /(.thisisagoddamnlongstringforstresstestingthequery|\sthisisagoddamnlongstringforstresstestingthequery)*-/ // $ Alert[js/redos]

var bad61 = /(thisisagoddamnlongstringforstresstestingthequery|this\w+query)*-/ // $ Alert[js/redos]


var good27 = /(thisisagoddamnlongstringforstresstestingthequery|imanotherbutunrelatedstringcomparedtotheotherstring)*-/


var good28 = /foo([\uDC66\uDC67]|[\uDC68\uDC69])*foo/


var good29 = /foo((\uDC66|\uDC67)|(\uDC68|\uDC69))*foo/

var bad62 = /a{2,3}(b+)+X/; // $ Alert[js/redos]

var bad63 = /^<(\w+)((?:\s+\w+(?:\s*=\s*(?:(?:"[^"]*")|(?:'[^']*')|[^>\s]+))?)*)\s*(\/?)>/; // $ Alert[js/redos] - and a good prefix test


var good30 = /(a+)*[^][^][^]?/;

// GOOD - but we fail to see that repeating the attack string ends in the "accept any" state (due to not parsing the range `[^]{2,3}`).
var good31 = /(a+)*[^]{2,3}/; // $ Alert[js/redos]

// GOOD - but we spuriously conclude that a rejecting suffix exists (due to not parsing the range `[^]{2,}` when constructing the NFA).
var good32 = /(a+)*([^]{2,}|X)$/; // $ Alert[js/redos]


var good33 = /(a+)*([^]*|X)$/;

var bad64 = /((a+)*$|[^]+)/; // $ Alert[js/redos]

var good34 = /([^]+|(a+)*$)/; // $ SPURIOUS: Alert[js/redos] - The only change compared to the above is the order of alternatives, which we don't model.


var good35 = /((;|^)a+)+$/;

var bad65 = /(^|;)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(0|1)(e+)+f/; // $ Alert[js/redos] - a good prefix test

var bad66 = /^ab(c+)+$/; // $ Alert[js/redos]

var bad67 = /(\d(\s+)*){20}/; // $ Alert[js/redos]

// OK - but we spuriously conclude that a rejecting suffix exists.
var good36 = /(([^/]|X)+)(\/[^]*)*$/; // $ Alert[js/redos]

// OK - but we spuriously conclude that a rejecting suffix exists.
var good37 = /^((x([^Y]+)?)*(Y|$))/; // $ Alert[js/redos]

var bad68 = /(a*)+b/; // $ Alert[js/redos]

var bad69 = /foo([\w-]*)+bar/; // $ Alert[js/redos]

var bad70 = /((ab)*)+c/; // $ Alert[js/redos]

var bad71 = /(a?a?)*b/; // $ Alert[js/redos]


var good38 = /(a?)*b/;

var bad72 = /(c?a?)*b/; // $ MISSING: Alert

var bad73 = /(?:a|a?)+b/; // $ Alert[js/redos]

var bad74 = /(a?b?)*$/; // $ MISSING: Alert

var bad76 = /PRE(([a-c]|[c-d])T(e?e?e?e?|X))+(cTcT|cTXcTX$)/; // $ Alert[js/redos]

var bad77 = /^((a)+\w)+$/; // $ Alert[js/redos]

var bad78 = /^(b+.)+$/; // $ Alert[js/redos]


var good39 = /a*b/;

// All 4 bad combinations of nested * and +)
var bad79 = /(a*)*b/; // $ Alert[js/redos]
var bad80 = /(a+)*b/; // $ Alert[js/redos]
var bad81 = /(a*)+b/; // $ Alert[js/redos]
var bad82 = /(a+)+b/; // $ Alert[js/redos]


var good40 = /(a|b)+/;
var good41 = /(?:[\s;,"'<>(){}|[\]@=+*]|:(?![/\\]))+/;

var bad83 = /^((?:a{|-)|\w\{)+X$/; // $ Alert[js/redos]
var bad84 = /^((?:a{0|-)|\w\{\d)+X$/; // $ Alert[js/redos]
var bad85 = /^((?:a{0,|-)|\w\{\d,)+X$/; // $ Alert[js/redos]
var bad86 = /^((?:a{0,2|-)|\w\{\d,\d)+X$/; // $ Alert[js/redos]

var bad86AndAHalf = /^((?:a{0,2}|-)|\w\{\d,\d\})+X$/; // $ MISSING: Alert


var good43 = /("[^"]*?"|[^"\s]+)+(?=\s*|\s*$)/g;

var bad87 = /("[^"]*?"|[^"\s]+)+(?=\s*|\s*$)X/g; // $ Alert[js/redos]
var bad88 = /("[^"]*?"|[^"\s]+)+(?=X)/g; // $ Alert[js/redos]
var bad89 = /(x*)+(?=$)/ // $ Alert[js/redos]
var bad90 = /(x*)+(?=$|y)/ // $ Alert[js/redos]

// OK - but we spuriously conclude that a rejecting suffix exists.
var good44 = /([\s\S]*)+(?=$)/; // $ Alert[js/redos]
var good45 = /([\s\S]*)+(?=$|y)/; // $ Alert[js/redos]

var good46 = /(foo|FOO)*bar/;
var bad91 = /(foo|FOO)*bar/i; // $ Alert[js/redos]

var good47 = /([AB]|[ab])*C/;
var bad92 = /([DE]|[de])*F/i; // $ Alert[js/redos]

var bad93 = /(?<=^v?|\sv?)(a|aa)*$/; // $ Alert[js/redos]
var bad94 = /(a|aa)*$/; // $ Alert[js/redos]

var bad95 = new RegExp(
    "(a" +
    "|" +
    "aa)*" +
    "b$" // $ Alert[js/redos]
);

var bad96 = new RegExp("(" +
    "(c|cc)*|" + // $ Alert[js/redos]
    "(d|dd)*|" + // $ Alert[js/redos]
    "(e|ee)*" +
")f$"); // $ Alert[js/redos]

var bad97 = new RegExp(
    "(g|gg" +
    ")*h$"); // $ Alert[js/redos]

var bad98 = /^(?:\*\/\*|[a-zA-Z0-9][a-zA-Z0-9!\#\$&\-\^_\.\+]{0,126}\/(?:\*|[a-zA-Z0-9][a-zA-Z0-9!\#\$&\-\^_\.\+]{0,126})(?:\s* *; *[a-zA-Z0-9][a-zA-Z0-9!\#\$&\-\^_\.\+]{0,126}(?:="?[a-zA-Z0-9][a-zA-Z0-9!\#\$&\-\^_\.\+]{0,126}"?)?\s*)*)$/; // $ Alert[js/redos]

var good48 = /(\/(?:\/[\w.-]*)*){0,1}:([\w.-]+)/;

var bad99 = /(a{1,})*b/; // $ Alert[js/redos]

var unicode = /^\n\u0000(\u0000|.)+$/; // $ Alert[js/redos]

var largeUnicode = new RegExp("^\n\u{1F680}(\u{1F680}|.)+X$"); // $ Alert[js/redos]

var unicodeSets = /(aa?)*b/v; // $ Alert[js/redos]
