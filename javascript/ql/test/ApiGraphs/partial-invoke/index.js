const cp = require('child_process');

module.exports = function () {
    return cp.spawn.bind(
        cp,   // def=moduleImport("child_process").getMember("exports").getMember("spawn").getReceiver()
        "cat" // def=moduleImport("child_process").getMember("exports").getMember("spawn").getParameter(0)
    );
};