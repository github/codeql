goog.module('test');

let esc = goog.require('goog.string.htmlEscape');

checkEscaped(esc('<script>'));
