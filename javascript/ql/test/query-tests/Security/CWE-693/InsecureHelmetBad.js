const express = require("express");
const helmet = require("helmet");

const app = express();

app.use(helmet({
    contentSecurityPolicy: false, // BAD: switch off default CSP
    frameguard: false // BAD: switch off default frameguard
}));

app.get("/", (req, res) => {
  res.send("Hello, world!");
});

app.listen(3000, () => {
  console.log("App is listening on port 3000");
});
