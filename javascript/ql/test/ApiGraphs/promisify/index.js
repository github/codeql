var bluebird = require("bluebird");
var readFile = require("fs").readFile;

var readFileAsync = bluebird.promisify(readFile);

readFile(
    "tst.txt", // def (parameter 0 (member readFile (member exports (module fs))))
    "utf8", // def (parameter 1 (member readFile (member exports (module fs))))
    function (
        err, // use (parameter 0 (parameter 2 (member readFile (member exports (module fs)))))
        contents // use (parameter 1 (parameter 2 (member readFile (member exports (module fs)))))
    ) { });

readFileAsync(
    "tst.txt"  // def (parameter 0 (member readFile (member exports (module fs))))
).then(
    function (buf) { } // use (parameter 1 (parameter 1 (member readFile (member exports (module fs)))))
).catch(
    function (err) { } // not yet modelled: (parameter 0 (parameter 1 (member readFile (member exports (module fs)))))
);

try {
    let p = readFileAsync(
        "tst.txt",  // def (parameter 0 (member readFile (member exports (module fs))))
        "utf8"  // def (parameter 1 (member readFile (member exports (module fs))))
    );
    let data = await p; // use (parameter 1 (parameter 2 (member readFile (member exports (module fs)))))
} catch (e) { } // not yet modelled: (parameter 0 (parameter 2 (member readFile (member exports (module fs)))))
