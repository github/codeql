import * as http from "http";
import * as url from "url";

export namespace Limits {
  export let max = 1024;
}

http.createServer((req, res) => {
  const query = url.parse(req.url, true).query; // $ Source
  const n = parseInt(query.n);
  const other = parseInt(query.other);

  Limits.max = other;
  Buffer.alloc(Math.min(n, Limits.max)); // $ Alert
});
