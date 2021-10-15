const express = require('express');
let app = express();

app.use("/admin", protect)
app.use("/", makeSubRouter())

function makeSubRouter() {
  var router = express.Router()
  router.post("/action1", handler1) // not affected by `protect`
  router.post("/admin/action2", handler2) // affected by `protect` (but not recognised)
  return router;
}
