// ...
express().post("/save", (req, res) => {
  fs.access(rootDir, (err) => {
    // ...
    try {
      save(rootDir, req.query.path, req.body); // GOOD exception is caught below
      res.status(200);
      res.end();
    } catch (e) {
      res.status(500);
      res.end();
    }
  });
});
