function checkEscaped(str) {
  if (str !== '&lt;script&gt;' && str !== '&#x3C;script&#x3E;' && str !== '&#60;script&#62;' && str !== '&lt;script>') {
    throw new Error('Not escaped: ' + str);
  }
}
function checkStripped(str) {
  if (str !== '') {
    throw new Error('Not stripped: ' + str);
  }
}
function checkNotEscaped(str) {
  if (str !== '<script>') {
    throw new Error('Escaped: ' + str);
  }
}

checkEscaped(require('ent').encode('<script>'));
checkEscaped(require('entities').encodeHTML('<script>'));
checkEscaped(require('entities').encodeXML('<script>'));
checkEscaped(require('escape-goat').escape('<script>'));
checkEscaped(require('he').encode('<script>'));
checkEscaped(require('he').escape('<script>'));
checkEscaped(require('lodash').escape('<script>'));
checkEscaped(require('sanitizer').escape('<script>'));
checkEscaped(require('underscore').escape('<script>'));
checkEscaped(require('validator').escape('<script>'));
checkEscaped(require('xss')('<script>'));
checkEscaped(require('xss-filters').inHTMLData('<script>'));
checkStripped(require('sanitize-html')('<script>'));
checkStripped(require('sanitizer').sanitize('<script>'));

let Entities = require('html-entities').Html5Entities;
checkEscaped(new Entities().encode('<script>'));
checkEscaped(new Entities().encodeNonUTF('<script>'));
checkEscaped(Entities.encode('<script>'));
checkEscaped(Entities.encodeNonUTF('<script>'));

checkNotEscaped(new Entities().encodeNonASCII('<script>'));
