var http = require("http");
http.request(x, data => data.on("data", d => undefined));
