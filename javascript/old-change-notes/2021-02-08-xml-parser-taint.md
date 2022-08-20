lgtm,codescanning
* The security queries now track taint through XML parsers. 
  Affected packages are
    [xml2js](https://www.npmjs.com/package/xml2js),
    [sax](https://www.npmjs.com/package/sax),
    [xml-js](https://www.npmjs.com/package/xml-js),
    [htmlparser2](https://www.npmjs.com/package/htmlparser2), and
    [node-expat](https://www.npmjs.com/package/node-expat)
