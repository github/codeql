const express = require("express");
const helmet = require("helmet");

const app = express();

app.use(helmet({
    contentSecurityPolicy: false, // $ RelatedLocation - switch off default CSP
    frameguard: false // $ RelatedLocation - switch off default frameguard
})); // $ Alert

app.get("/", (req, res) => {
  res.send("Hello, world!");
});

app.listen(3000, () => {
  console.log("App is listening on port 3000");
});
