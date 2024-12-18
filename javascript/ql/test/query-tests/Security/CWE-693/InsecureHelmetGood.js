const express = require("express");
const helmet = require("helmet");

const app = express();

app.use(helmet());  // GOOD: use the defaults

app.get("/", (req, res) => {
  res.send("Hello, world!");
});

app.listen(3000, () => {
  console.log("App is listening on port 3000");
});
