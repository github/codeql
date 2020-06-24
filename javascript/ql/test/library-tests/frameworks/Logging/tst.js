var requiredConsole = require("console");

console.log("msg %s", arg);
console.fatal("msg %s", arg);
console.debug("msg %s", arg);

requiredConsole.log("msg %s", arg);

require("loglevel").log("msg %s", arg);

require("winston").createLogger().log({ message: "msg with arg" }, other);
require("winston").createLogger().info("msg %s", arg);

require("log4js").getLogger().log("msg %s", arg);

console.assert(true, "msg %s", arg);

let log = console.log;
log("msg %s", arg);
