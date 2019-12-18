// NOT GOOD; attack: "_" + "__".repeat(100)
// Adapted from marked (https://github.com/markedjs/marked), which is licensed
// under the MIT license; see file marked-LICENSE.
var bad1 = /^\b_((?:__|[\s\S])+?)_\b|^\*((?:\*\*|[\s\S])+?)\*(?!\*)/;

// GOOD
// Adapted from marked (https://github.com/markedjs/marked), which is licensed
// under the MIT license; see file marked-LICENSE.
var good1 = /^\b_((?:__|[^_])+?)_\b|^\*((?:\*\*|[^*])+?)\*(?!\*)/;

// NOT GOOD
// Adapted from brace-expansion (https://github.com/juliangruber/brace-expansion),
// which is licensed under the MIT license; see file brace-expansion-LICENSE.
var bad2 = /(.*,)+.+/;

// NOT GOOD; attack: " '" + "\\\\".repeat(100)
// Adapted from CodeMirror (https://github.com/codemirror/codemirror),
// which is licensed under the MIT license; see file CodeMirror-LICENSE.
var bad3 = /^(?:\s+(?:"(?:[^"\\]|\\\\|\\.)+"|'(?:[^'\\]|\\\\|\\.)+'|\((?:[^)\\]|\\\\|\\.)+\)))?/;

// GOOD
// Adapted from lulucms2 (https://github.com/yiifans/lulucms2).
var good2 = /\(\*(?:[\s\S]*?\(\*[\s\S]*?\*\))*[\s\S]*?\*\)/;

// GOOD
// Adapted from jest (https://github.com/facebook/jest), which is licensed
// under the MIT license; see file jest-LICENSE.
var good3 = /^ *(\S.*\|.*)\n *([-:]+ *\|[-| :]*)\n((?:.*\|.*(?:\n|$))*)\n*/;

// NOT GOOD, variant of good3; attack: "a|\n:|\n" + "||\n".repeat(100)
var bad4 = /^ *(\S.*\|.*)\n *([-:]+ *\|[-| :]*)\n((?:.*\|.*(?:\n|$))*)a/;

// NOT GOOD; attack: "/" + "\\/a".repeat(100)
// Adapted from ANodeBlog (https://github.com/gefangshuai/ANodeBlog),
// which is licensed under the Apache License 2.0; see file ANodeBlog-LICENSE.
var bad5 = /\/(?![ *])(\\\/|.)*?\/[gim]*(?=\W|$)/;

// NOT GOOD; attack: "##".repeat(100) + "\na"
// Adapted from CodeMirror (https://github.com/codemirror/codemirror),
// which is licensed under the MIT license; see file CodeMirror-LICENSE.
var bad6 = /^([\s\[\{\(]|#.*)*$/;

// GOOD
var good4 = /(\r\n|\r|\n)+/;

// GOOD because it cannot be made to fail after the loop (but we can't tell that)
var good5 = /((?:[^"']|".*?"|'.*?')*?)([(,)]|$)/;

// NOT GOOD; attack: "a" + "[]".repeat(100) + ".b\n"
// Adapted from Knockout (https://github.com/knockout/knockout), which is
// licensed under the MIT license; see file knockout-LICENSE
var bad6 = /^[\_$a-z][\_$a-z0-9]*(\[.*?\])*(\.[\_$a-z][\_$a-z0-9]*(\[.*?\])*)*$/i;

// GOOD
var good6 = /(a|.)*/;

// NOT GOOD; we cannot detect all of them due to the way we build our NFAs
var bad7 = /^([a-z]+)+$/;
var bad8 = /^([a-z]*)*$/;
var bad9 = /^([a-zA-Z0-9])(([\\-.]|[_]+)?([a-zA-Z0-9]+))*(@){1}[a-z0-9]+[.]{1}(([a-z]{2,3})|([a-z]{2,3}[.]{1}[a-z]{2,3}))$/;
var bad10 = /^(([a-z])+.)+[A-Z]([a-z])+$/;

// NOT GOOD; attack: "[" + "][".repeat(100) + "]!"
// Adapted from Prototype.js (https://github.com/prototypejs/prototype), which
// is licensed under the MIT license; see file Prototype.js-LICENSE.
var bad11 = /(([\w#:.~>+()\s-]+|\*|\[.*?\])+)\s*(,|$)/;

// NOT GOOD; attack: "'" + "\\a".repeat(100) + '"'
// Adapted from Prism (https://github.com/PrismJS/prism), which is licensed
// under the MIT license; see file Prism-LICENSE.
var bad12 = /("|')(\\?.)*?\1/g;

// NOT GOOD
var bad13 = /(b|a?b)*c/;

// NOT GOOD
var bad15 = /(a|aa?)*b/;

// GOOD
var good7 = /(.|\n)*!/;

// NOT GOOD; attack: "\n".repeat(100) + "."
var bad16 = /(.|\n)*!/s;

// GOOD
var good8 = /([\w.]+)*/;

// NOT GOOD
var bad17 = new RegExp('(a|aa?)*b');

// GOOD - not used as regexp
var good9 = '(a|aa?)*b';
