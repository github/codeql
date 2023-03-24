const express = require("express");
const app = express();

const cp = require("child_process");

app.get("/ls-remote", (req, res) => {
  const remote = req.query.remote;
  cp.execFile("git", ["ls-remote", remote]); // NOT OK
});
