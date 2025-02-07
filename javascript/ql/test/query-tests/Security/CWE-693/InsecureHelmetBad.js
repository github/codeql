const express = require("express");
const helmet = require("helmet");

const app = express();

app.use(helmet({
    contentSecurityPolicy: false, // $ TODO-MISSING: Alert - switch off default CSP
    frameguard: false // $ TODO-MISSING: Alert - switch off default frameguard
})); // $ TODO-SPURIOUS: Alert

app.get("/", (req, res) => {
  res.send("Hello, world!");
});

app.listen(3000, () => {
  console.log("App is listening on port 3000");
});
