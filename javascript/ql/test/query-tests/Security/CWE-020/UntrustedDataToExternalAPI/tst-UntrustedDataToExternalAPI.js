let externalLib = require('external-lib');

let untrusted = window.name; // $ Source

externalLib(untrusted); // $ Alert
externalLib({x: untrusted}); // $ Alert
externalLib(...untrusted); // $ Alert
externalLib(...window.CONFIG, untrusted); // $ Alert
externalLib({ ...untrusted }); // $ Alert
externalLib(['x', untrusted, 'y']); // $ Alert
externalLib('foo', untrusted); // $ Alert
externalLib({
    x: {
        y: {
            z: untrusted
        }
    } // $ Alert
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
    res.send(untrusted); // $ Alert
    req.app.locals.something.foo(untrusted); // $ Alert
});

let jsonSafeParse = require('json-safe-parse');
jsonSafeParse(untrusted); // no need to report; has known taint step

let merge = require('lodash.merge');
merge({}, { // $ Alert
    x: untrusted, // should not be treated as individual named parameters
    y: untrusted,
    z: untrusted
}); // $ Alert
