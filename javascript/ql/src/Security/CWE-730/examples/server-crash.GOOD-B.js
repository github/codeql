// ...
express().post("/save", async (req, res) => {
  if (!(await fs.promises.exists(rootDir))) {
    console.error(`Server setup is corrupted, ${rootDir} does not exist!`);
    res.status(500);
    res.end();
    return;
  }
  save(rootDir, req.query.path, req.body); // MAYBE BAD, depends on the commandline options
  res.status(200);
  res.end();
});
