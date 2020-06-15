const app = require("express")();

app.post("/notify", function handler(req, res) {
  const delay = req.body['delay'] || 200;
  setTimeout(() => {
    notifyUser();
  }, delay)
});
