const cp = require("child_process");
const http = require("http");

http.createServer((req, res) => {
  const input = req.url; // $ Source
  const command = "ls " + input;

  cp.spawn("/usr/bin/env", ["sh", "-c", command]); // $ Alert
  cp.execFile("env", ["bash", "-c", command]); // $ Alert
  cp.spawn("nice", ["sh", "-c", command]); // $ Alert
  cp.spawnSync("/usr/bin/nice", ["-n", "5", "/bin/bash", "-c", command]); // $ Alert
  cp.execFileSync("/bin/env", ["-i", "-u", "OLD", "FOO=bar", "sh", "-c", command]); // $ Alert
  cp.spawn("env", ["--", "FOO=bar", "sh", "-c", command]); // $ Alert
  cp.spawn("env", ["--unset=FOO", "sh", "-c", command]); // $ Alert
  cp.spawn("nice", ["--adjustment=5", "--", "sh", "-c", command]); // $ Alert
  const shell = "sh";
  const args = [shell, "-c", command]; // $ Sink
  cp.spawn("env", args); // $ Alert
  runWithLauncher(["sh", "-c", command]); // $ Sink

  cp.spawn("env", ["echo", "sh", "-c", command]);
  cp.spawn("env", ["echo"].concat(["sh", "-c", command]));
  cp.spawn("nice", ["echo", "sh", "-c", command]);
  cp.spawn("env", ["-u", "sh", "-c", command]);
  cp.spawn("env", ["sh", "-c", "echo safe", input]);
  cp.spawn("env", ["sh", input, "-c", "echo safe"]);
  cp.spawn("env", ["FOO=" + input, "sh", "-c", "echo safe"]);
  cp.spawn("other", ["sh", "-c", command]);
  cp.spawn("env", ["sh", "-c", ...[command]]);

  const overwritten = ["sh", "-c", command];
  overwritten[0] = "echo";
  cp.spawn("env", overwritten);

  const overwrittenCommand = ["sh", "-c", command];
  overwrittenCommand[2] = "echo safe";
  cp.spawn("env", overwrittenCommand);

  const shifted = ["sh", "-c", command];
  shifted.unshift("echo");
  cp.spawn("env", shifted);

  const laterChange = ["sh", "-c", command]; // $ Sink
  cp.spawn("env", laterChange); // $ Alert
  laterChange[0] = "echo";

  const conditional = ["sh", "-c", command]; // $ Sink
  if (input) conditional[0] = "echo";
  cp.spawn("env", conditional); // $ Alert
});

function runWithLauncher(args) {
  cp.spawn("env", args); // $ Alert
}
