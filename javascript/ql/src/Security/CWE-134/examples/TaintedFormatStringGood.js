const app = require("express")();

app.get("unauthorized", function handler(req, res) {
  let user = req.query.user;
  let ip = req.connection.remoteAddress;
  console.log("Unauthorized access attempt by %s", user, ip);
});
