const childProcess = require("node:child_process");
const spawn = childProcess.spawn;
childProcess.spawn = function (...args) {
    const child = spawn.apply(this, args);
    child.kill();
    return child;
};
