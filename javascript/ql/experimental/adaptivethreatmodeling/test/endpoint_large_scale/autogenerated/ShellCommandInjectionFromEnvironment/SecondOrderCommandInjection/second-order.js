const express = require("express");
const app = express();
const { execFile } = require("child_process");

app.get("/", (req, res) => {
  const remote = req.query.remote;
  execFile("git", ["ls-remote", remote]); // NOT OK

  execFile("git", ["fetch", remote]); // NOT OK

  indirect("git", ["ls-remote", remote]); // NOT OK

  const myArgs = req.query.args;

  execFile("git", myArgs); // NOT OK

  if (remote.startsWith("--")) {
    execFile("git", ["ls-remote", remote, "HEAD"]); // OK - it is very explicit that options that allowed here. 
  } else {
    execFile("git", ["ls-remote", remote, "HEAD"]); // OK - it's not an option
  }

  if (remote.startsWith("git@")) {
    execFile("git", ["ls-remote", remote, "HEAD"]); // OK - it's a git URL
  } else {
    execFile("git", ["ls-remote", remote, "HEAD"]); // NOT OK - unknown starting string
  }

  execFile("git", req.query.args); // NOT OK - unknown args

  execFile("git", ["add", req.query.args]); // OK - git add is not a command that can be used to execute arbitrary code

  execFile("git", ["add", req.query.remote].concat([otherargs()])); // OK - git add is not a command that can be used to execute arbitrary code

  execFile("git", ["ls-remote", req.query.remote].concat(req.query.otherArgs)); // NOT OK - but not found [INCONSISTENCY]. It's hard to track through concat.

  execFile("git", ["add", "fpp"].concat(req.query.notVulnerable)); // OK

  // hg
  execFile("hg", ["clone", req.query.remote]); // NOT OK

  execFile("hg", ["whatever", req.query.remote]); // NOT OK - `--config=alias.whatever=touch pwned`

  execFile("hg", req.query.args); // NOT OK - unknown args

  execFile("hg", ["clone", "--", req.query.remote]); // OK
});

function indirect(cmd, args) {
  execFile(cmd, args); //  - OK - ish, the vulnerability not reported here
}

app.listen(3000, () => console.log("Example app listening on port 3000!"));
