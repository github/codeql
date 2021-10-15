(function () {
    var Parser = require("node-expat").Parser
    var parser = new Parser();

    parser.write(source());

    parser.on("text", text => {
        sink(text); // NOT OK
    });

    var parseString = require('xml2js').parseString;
    parseString(source(), function (err, result) {
        sink(result); // NOT OK
    });

    var sax = require("sax");
    var parser = sax.parser(strict);
    
    parser.onattribute = function (attr) {
        sink(attr); // NOT OK
    };
    
    parser.write(source()).close();

    var convert = require('xml-js');
    sink(convert.xml2json(source(), {})); // NOT OK

    const htmlparser2 = require("htmlparser2");
    const parser = new htmlparser2.Parser({
        onopentag(name, attributes) {
            sink(name) // NOT OK
        }
    });
    parser.write(source());
    parser.end();

})();

(function () {
    var libxml = require("libxmljs");
    var xml = source();
    var xmlDoc = libxml.parseXmlString(xml);
    var gchild = xmlDoc.get('//grandchild');
    sink(gchild.text()); // NOT OK

    var children = xmlDoc.root().childNodes();
    var child = children[0];

    sink(child.attr('foo').value()); // NOT OK

    var child2 = xmlDoc.root().child()
    sink(child2.attr('foo').name()); // NOT OK

    const SaxPushParser = libxml.SaxPushParser;
    var parser = new SaxPushParser();
    parser.push(xml);
    parser.on('characters', function (str) {
      sink(str); // NOT OK
    })    
});