const fs = require("fs"),
    fse = require("fs-extra"),
    base64 = require("base-64");

module.exports.readFile = function (f) {
    return new Promise((res, rej) => {
        fs.readFile(f, (err, data) => {
            if (err)
                rej(err);
            else
                res(data); /* def (promised (return (member readFile (member exports (module promises))))) */
        });
    });
};

module.exports.readFileAndEncode = function (f) {
    return fse.readFile(f)
        .then((data) => /* use (promised (return (member readFile (member exports (module fs-extra))))) */
            base64.encode(data) /* def (promised (return (member readFileAndEncode (member exports (module promises))))) */
        );
};