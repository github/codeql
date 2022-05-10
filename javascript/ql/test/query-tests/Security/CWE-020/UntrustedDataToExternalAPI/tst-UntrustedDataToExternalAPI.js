let externalLib = require('external-lib');

let untrusted = window.name;

externalLib(untrusted);
externalLib({x: untrusted});
externalLib(...untrusted);
externalLib(...window.CONFIG, untrusted);
externalLib({ ...untrusted });
externalLib(['x', untrusted, 'y']);
externalLib('foo', untrusted);
externalLib({
    x: {
        y: {
            z: untrusted
        }
    }
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
    res.send(untrusted);
    req.app.locals.something.foo(untrusted);
});

let jsonSafeParse = require('json-safe-parse');
jsonSafeParse(untrusted); // no need to report; has known taint step

let merge = require('lodash.merge');
merge({}, {
    x: untrusted, // should not be treated as individual named parameters
    y: untrusted,
    z: untrusted
});
