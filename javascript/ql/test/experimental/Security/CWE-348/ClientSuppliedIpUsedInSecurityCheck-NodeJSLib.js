const http = require("http");

const getClientIPBad = (req) => {
  var ip = req.headers["x-forwarded-for"];

  return ip;
};

const getClientIPGood = (req) => {
  var ip = req.headers["x-forwarded-for"];

  if (!ip) {
    return "";
  }

  // Good: if this application runs behind a reverse proxy it may append the real remote IP to the end of any client-supplied X-Forwarded-For header.
  ip = ip.split(",")[ip.split(",").length - 1];
  return ip;
};

const requestListener = function (req, res) {
  if (req.url === "/bad1") {
    var ip = getClientIPBad(req);

    if (ip && ip === "127.0.0.1") {
      res.writeHead(200);
      return res.end("Hello, World!");
    }

    res.writeHead(403);
    return res.end("illegal ip");
  } else if (req.url === "/bad2") {
    var ip = req.headers["x-forwarded-for"];

    if (ip && ip.startsWith("10.")) {
      res.writeHead(200);
      return res.end("Hello, World!");
    }

    res.writeHead(403);
    return res.end("illegal ip");
  } else if (req.url === "/bad3") {
    var ip = req.headers["x-forwarded-for"];

    if (ip && ip.includes("172.16.")) {
      res.writeHead(200);
      return res.end("Hello, World!");
    }

    res.writeHead(403);
    return res.end("illegal ip");
  } else if (req.url === "/bad4") {
    var ip = req.headers["x-forwarded-for"];

    if (!ip) {
      res.writeHead(403);
      return res.end("illegal ip");
    }

    ip = ip.split(",")[0];

    if (ip && ip.startsWith("172.31.")) {
      res.writeHead(200);
      return res.end("Hello, World!");
    }

    res.writeHead(403);
    return res.end("illegal ip");
  } else if (req.url === "/bad5") {
    var ip = req.headers["x-forwarded-for"];

    if (!ip) {
      res.writeHead(403);
      return res.end("illegal ip");
    }

    var temp = ip.split(",");
    ip = temp[0];

    if (ip && ip.startsWith("192.168.")) {
      res.writeHead(200);
      return res.end("Hello, World!");
    }

    res.writeHead(403);
    return res.end("illegal ip");
  } else if (req.url === "/false-positive-1") {
    var ip = []["x-forwarded-for"];

    if (ip && ip.startsWith("10.")) {
      res.writeHead(200);
      return res.end("Hello, World!");
    }

    res.writeHead(403);
    return res.end("illegal ip");
  } else if (req.url === "/good1") {
    var ip = getClientIPGood(req);

    if (ip && ip === "127.0.0.1") {
      res.writeHead(200);
      return res.end("Hello, World!");
    }

    res.writeHead(403);
    return res.end("illegal ip");
  } else if (req.url === "/good2") {
    var ip = req.headers["x-forwarded-for"];

    if (!ip) {
      res.writeHead(403);
      return res.end("illegal ip");
    }

    ip = ip.split(",")[ip.split(",").length - 1];

    if (ip && ip.startsWith("10.")) {
      res.writeHead(200);
      return res.end("Hello, World!");
    }

    res.writeHead(403);
    return res.end("illegal ip");
  } else if (req.url === "/good3") {
    var ip = req.headers["x-forwarded-for"];

    if (!ip) {
      res.writeHead(403);
      return res.end("illegal ip");
    }

    var temp = ip.split(",");
    ip = temp[temp.length - 1];

    if (ip && ip.startsWith("172.16.")) {
      res.writeHead(200);
      return res.end("Hello, World!");
    }

    res.writeHead(403);
    return res.end("illegal ip");
  } else if (req.url === "/good4") {
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
    return res.end("illegal ip");
  } else if (req.url === "/good5") {
    var ip = req.headers["x-forwarded-for"];

    if (!ip) {
      res.writeHead(403);
      return res.end("illegal ip");
    }

    // Good: if this application runs behind a reverse proxy it may append the real remote IP to the end of any client-supplied X-Forwarded-For header.
    var temp1 = ip.split(",");
    var temp2 = temp1;
    ip = temp2.pop();

    if (ip && ip.includes("192.168.")) {
      res.writeHead(200);
      return res.end("Hello, World!");
    }

    res.writeHead(403);
    return res.end("illegal ip");
  } else {
    res.writeHead(404);
    res.end("Not Found!");
  }
};

const server = http.createServer(requestListener);
server.listen(3000);
