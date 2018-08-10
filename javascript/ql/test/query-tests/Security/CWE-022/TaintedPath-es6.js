import { readFileSync } from 'fs';
import { createServer } from 'http';
import { parse } from 'url';
import { join } from 'path';

var server = createServer(function(req, res) {
  let path = parse(req.url, true).query.path;

  // BAD: This could read any file on the file system
  res.write(readFileSync(join("public", path)));
});
