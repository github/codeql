// ...
express().post("/save", async (req, res) => {
  try {
    await fs.promises.access(rootDir);
    save(rootDir, req.query.path, req.body); // GOOD exception is caught below
    res.status(200);
    res.end();
  } catch (e) {
    res.status(500);
    res.end();
  }
});
