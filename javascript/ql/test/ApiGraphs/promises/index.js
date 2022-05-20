const fs = require("fs"),
    fse = require("fs-extra"),
    base64 = require("base-64");

module.exports.readFile = function (f) {
    return new Promise((res, rej) => {
        fs.readFile(f, (err, data) => {
            if (err)
                rej(err);
            else
                res(data); /* def=moduleImport("promises").getMember("exports").getMember("readFile").getReturn().getPromised() */
        });
    });
};

module.exports.readFileAndEncode = function (f) {
    return fse.readFile(f)
        .then((data) => /* use=moduleImport("fs-extra").getMember("exports").getMember("readFile").getReturn().getPromised() */
            base64.encode(data) /* def=moduleImport("promises").getMember("exports").getMember("readFileAndEncode").getReturn().getPromised() */
        );
};