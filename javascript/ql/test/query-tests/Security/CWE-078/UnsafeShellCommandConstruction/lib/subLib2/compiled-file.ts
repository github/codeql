var cp = require("child_process")

export default function (name) {
    cp.exec("rm -rf " + name); // NOT OK - the "files" directory points to this file.
}
