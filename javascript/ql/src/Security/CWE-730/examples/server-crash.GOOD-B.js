// ...
express().post("/save", async (req, res) => {
  try {
    await fs.access(rootDir);
  } catch (e) {
    console.error(`Server setup is corrupted, ${rootDir} does not exist!`);
    res.status(500);
    res.end();
  }
  save(rootDir, req.query.path, req.body); // MAYBE BAD, depends on the commandline options
  res.status(200);
  res.end();
});
