const cp = require('child_process');

module.exports = function () {
    return cp.spawn.bind(
        cp,   // def (receiver (member spawn (member exports (module child_process))))
        "cat" // def (parameter 0 (member spawn (member exports (module child_process))))
    );
};