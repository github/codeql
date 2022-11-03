const fs = require('fs');

exports.foo = function (cb) {
    if (!cb)
        cb = function () { };
    cb(fs.readFileSync("/etc/passwd")); /* def (parameter 0 (parameter 0 (member foo (member exports (module branching-flow))))) */
};