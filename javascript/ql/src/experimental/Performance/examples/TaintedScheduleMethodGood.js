const app = require("express")();

app.post("/notify", function handler(req, res) {
  const delay = req.body['delay'] || 200;
  const maxDelay = 3600000; // 1 hour
  const cappedDelay = delay > maxDelay ? maxDelay : delay;

  setTimeout(() => {
    notifyUser();
  }, cappedDelay)
});
