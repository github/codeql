const express = require("express"),
  fs = require("fs");

function save(rootDir, path, content) {
  if (!isValidPath(rootDir, req.query.filePath)) {
    throw new Error(`Invalid filePath: ${req.query.filePath}`); // BAD crashes the server
  }
  // write content to disk
}

express().post("/save", (req, res) => {
  fs.access(rootDir, (err) => {
    if (err) {
      console.error(
        `Server setup is corrupted, ${rootDir} cannot be accessed!`
      );
      res.status(500);
      res.end();
      return;
    }
    save(rootDir, req.query.path, req.body);
    res.status(200);
    res.end();
  });
});
