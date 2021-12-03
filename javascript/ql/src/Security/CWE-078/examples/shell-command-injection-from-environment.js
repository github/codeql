var cp = require("child_process"),
  path = require("path");
function cleanupTemp() {
  let cmd = "rm -rf " + path.join(__dirname, "temp");
  cp.execSync(cmd); // BAD
}
