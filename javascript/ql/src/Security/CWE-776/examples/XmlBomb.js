const expat = require('node-expat');
var parser = new expat.Parser();
parser.on('startElement', handleStart);
parser.on('text', handleText);
parser.write(xmlSrc);
