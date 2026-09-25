const express = require("express");
const app = express();
const port = 3000;

app.get("/bad1", (req, res) => {
  var ip = req.headers["x-forwarded-for"];

  // Bad: use this value directly
  if (ip && ip === "127.0.0.1") {
    res.writeHead(200);
    return res.end("Hello, World!");
  }

  res.writeHead(403);
  res.end("illegal ip");
});

app.get("/bad2", (req, res) => {
  var ip = req.headers["x-forwarded-for"];
  if (!ip) {
    res.writeHead(403);
    return res.end("illegal ip");
  }

  // Bad: the first IP is used
  var temp = ip.split(",");
  ip = temp[0];

  if (ip && ip === "127.0.0.1") {
    res.writeHead(200);
    return res.end("Hello, World!");
  }

  res.writeHead(403);
  res.end("illegal ip");
});

app.get("/good", (req, res) => {
  var ip = req.headers["x-forwarded-for"];
  if (!ip) {
    res.writeHead(403);
    return res.end("illegal ip");
  }

  // Good: if this application runs behind a reverse proxy it may append the real remote IP to the end of any client-supplied X-Forwarded-For header.
  var temp = ip.split(",");
  ip = temp[temp.length - 1];

  if (ip && ip === "127.0.0.1") {
    res.writeHead(200);
    return res.end("Hello, World!");
  }

  res.writeHead(403);
  res.end("illegal ip");
});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});
