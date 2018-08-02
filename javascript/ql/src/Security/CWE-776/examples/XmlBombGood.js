const sax = require('sax');
var parser = sax.parser(true);
parser.onopentag = handleStart;
parser.ontext = handleText;
parser.write(xmlSrc);
