const express = require("express");
const app = express();

const cp = require("child_process");

app.get("/ls-remote", (req, res) => {
  const remote = req.query.remote;
  if (!(remote.startsWith("git@") || remote.startsWith("https://"))) {
    throw new Error("Invalid remote: " + remote);
  }
  cp.execFile("git", ["ls-remote", remote]); // OK
});
