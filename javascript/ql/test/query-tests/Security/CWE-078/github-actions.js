const core = require("@actions/core"),
  github = require("@actions/github"),
  cp = require("child_process");

function test() {
  cp.exec(core.getInput("user-input")); // NOT OK
  cp.exec(github.context.payload.inputs["user-input"]); // NOT OK
}
