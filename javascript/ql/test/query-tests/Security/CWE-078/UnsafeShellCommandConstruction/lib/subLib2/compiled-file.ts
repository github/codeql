var cp = require("child_process")

export default function (name) { // $ Source
    cp.exec("rm -rf " + name); // $ Alert Sink - the "files" directory points to this file.
}
