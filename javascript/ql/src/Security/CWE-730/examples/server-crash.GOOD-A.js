// ...
express().post("/save", (req, res) => {
  fs.exists(rootDir, (exists) => {
    // ...
    try {
      save(rootDir, req.query.path, req.body); // GOOD no uncaught exception
      res.status(200);
      res.end();
    } catch (e) {
      res.status(500);
      res.end();
    }
  });
});
