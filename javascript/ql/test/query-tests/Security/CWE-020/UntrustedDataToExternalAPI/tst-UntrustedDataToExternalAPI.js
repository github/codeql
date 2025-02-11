let externalLib = require('external-lib');

let untrusted = window.name;

externalLib(untrusted); // $ TODO-SPURIOUS: Alert
externalLib({x: untrusted}); // $ TODO-SPURIOUS: Alert
externalLib(...untrusted); // $ TODO-SPURIOUS: Alert
externalLib(...window.CONFIG, untrusted); // $ TODO-SPURIOUS: Alert
externalLib({ ...untrusted }); // $ TODO-SPURIOUS: Alert
externalLib(['x', untrusted, 'y']); // $ TODO-SPURIOUS: Alert
externalLib('foo', untrusted); // $ TODO-SPURIOUS: Alert
externalLib({
    x: {
        y: {
            z: untrusted
        }
    } // $ TODO-SPURIOUS: Alert
});

function getDeepUntrusted() {
    return {
        x: {
            y: {
                z: [JSON.parse(untrusted)]
            }
        }
    }
}

externalLib(getDeepUntrusted());

externalLib.get('/foo', (req, res) => {
    res.send(untrusted); // $ TODO-SPURIOUS: Alert
    req.app.locals.something.foo(untrusted); // $ TODO-SPURIOUS: Alert
});

let jsonSafeParse = require('json-safe-parse');
jsonSafeParse(untrusted); // no need to report; has known taint step

let merge = require('lodash.merge');
merge({}, { // $ TODO-SPURIOUS: Alert
    x: untrusted, // should not be treated as individual named parameters
    y: untrusted,
    z: untrusted
}); // $ TODO-SPURIOUS: Alert
