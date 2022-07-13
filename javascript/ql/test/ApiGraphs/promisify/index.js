var bluebird = require("bluebird");
var readFile = require("fs").readFile;

var readFileAsync = bluebird.promisify(readFile);

readFile(
    "tst.txt", // def=moduleImport("fs").getMember("exports").getMember("readFile").getParameter(0)
    "utf8", // def=moduleImport("fs").getMember("exports").getMember("readFile").getParameter(1)
    function (
        err, // use=moduleImport("fs").getMember("exports").getMember("readFile").getParameter(2).getParameter(0)
        contents // use=moduleImport("fs").getMember("exports").getMember("readFile").getParameter(2).getParameter(1)
    ) { });

readFileAsync(
    "tst.txt"  // def=moduleImport("fs").getMember("exports").getMember("readFile").getParameter(0)
).then(
    function (buf) { } // use=moduleImport("fs").getMember("exports").getMember("readFile").getParameter(1).getParameter(1)
).catch(
    function (err) { } // not yet modelled: (parameter 0 (parameter 1 (member readFile (member exports (module fs)))))
);

try {
    let p = readFileAsync(
        "tst.txt",  // def=moduleImport("fs").getMember("exports").getMember("readFile").getParameter(0)
        "utf8"  // def=moduleImport("fs").getMember("exports").getMember("readFile").getParameter(1)
    );
    let data = await p; // use=moduleImport("fs").getMember("exports").getMember("readFile").getParameter(2).getParameter(1)
} catch (e) { } // not yet modelled: (parameter 0 (parameter 2 (member readFile (member exports (module fs)))))
