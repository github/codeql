const express = require("express");
const app = express();
const port = 3000;

const getClientIPBad = (req) => {
  var ip = req.headers["x-forwarded-for"];
  return ip;
};

app.get("/bad1", (req, res) => {
  var ip = getClientIPBad(req);

  if (ip && ip === "127.0.0.1") {
    res.writeHead(200);
    return res.end("Hello, World!");
  }

  res.writeHead(403);
  res.end("illegal ip");
});

app.get("/bad2", (req, res) => {
  var ip = req.headers["x-forwarded-for"];

  if (ip && ip.startsWith("10.")) {
    res.writeHead(200);
    return res.end("Hello, World!");
  }

  res.writeHead(403);
  res.end("illegal ip");
});

app.get("/bad3", (req, res) => {
  var ip = req.headers["x-forwarded-for"];

  if (ip && ip.includes("172.16.")) {
    res.writeHead(200);
    return res.end("Hello, World!");
  }

  res.writeHead(403);
  res.end("illegal ip");
});

app.get("/bad4", (req, res) => {
  var ip = req.headers["x-forwarded-for"];

  if (!ip) {
    res.writeHead(403);
    return res.end("illegal ip");
  }

  ip = ip.split(",")[0];

  if (ip && ip.includes("172.31.")) {
    res.writeHead(200);
    return res.end("Hello, World!");
  }

  res.writeHead(403);
  res.end("illegal ip");
});

app.get("/bad5", (req, res) => {
  var ip = req.headers["x-forwarded-for"];

  if (!ip) {
    res.writeHead(403);
    return res.end("illegal ip");
  }

  var temp = ip.split(",");
  ip = temp[0];

  if (ip && ip.includes("192.168.")) {
    res.writeHead(200);
    return res.end("Hello, World!");
  }

  res.writeHead(403);
  res.end("illegal ip");
});

app.get("/false-positive-1", (req, res) => {
  var temp = [];
  var ip = temp["x-forwarded-for"];

  if (ip && ip === "127.0.0.1") {
    res.writeHead(200);
    return res.end("Hello, World!");
  }

  res.writeHead(403);
  res.end("illegal ip");
});

const getClientIPGood = (req) => {
  var ip = req.headers["x-forwarded-for"];

  if (!ip) {
    return "";
  }

  // Good: if this application runs behind a reverse proxy it may append the real remote IP to the end of any client-supplied X-Forwarded-For header.
  ip = ip.split(",")[ip.split(",").length - 1];
  return ip;
};

app.get("/good1", (req, res) => {
  var ip = getClientIPGood(req);

  if (ip && ip === "127.0.0.1") {
    res.writeHead(200);
    return res.end("Hello, World!");
  }

  res.writeHead(403);
  res.end("illegal ip");
});

app.get("/good2", (req, res) => {
  var ip = req.headers["x-forwarded-for"];

  if (!ip) {
    res.writeHead(403);
    return res.end("illegal ip");
  }

  // Good: if this application runs behind a reverse proxy it may append the real remote IP to the end of any client-supplied X-Forwarded-For header.
  ip = ip.split(",")[ip.split(",").length - 1];

  if (ip && ip.startsWith("10.")) {
    res.writeHead(200);
    return res.end("Hello, World!");
  }

  res.writeHead(403);
  res.end("illegal ip");
});

app.get("/good3", (req, res) => {
  var ip = req.headers["x-forwarded-for"];

  if (!ip) {
    res.writeHead(403);
    return res.end("illegal ip");
  }

  // Good: if this application runs behind a reverse proxy it may append the real remote IP to the end of any client-supplied X-Forwarded-For header.
  var temp = ip.split(",");
  ip = temp[temp.length - 1];

  if (ip && ip.includes("172.16.")) {
    res.writeHead(200);
    return res.end("Hello, World!");
  }

  res.writeHead(403);
  res.end("illegal ip");
});

app.get("/good4", (req, res) => {
  var ip = req.headers["x-forwarded-for"];

  if (!ip) {
    res.writeHead(403);
    return res.end("illegal ip");
  }

  // Good: if this application runs behind a reverse proxy it may append the real remote IP to the end of any client-supplied X-Forwarded-For header.
  ip = ip.split(",").pop();

  if (ip && ip.includes("172.31.")) {
    res.writeHead(200);
    return res.end("Hello, World!");
  }

  res.writeHead(403);
  res.end("illegal ip");
});

app.get("/good5", (req, res) => {
  var ip = req.headers["x-forwarded-for"];

  if (!ip) {
    res.writeHead(403);
    return res.end("illegal ip");
  }

  // Good: if this application runs behind a reverse proxy it may append the real remote IP to the end of any client-supplied X-Forwarded-For header.
  var temp = ip.split(",");
  ip = temp.pop();

  if (ip && ip.includes("192.168.")) {
    res.writeHead(200);
    return res.end("Hello, World!");
  }

  res.writeHead(403);
  res.end("illegal ip");
});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});
