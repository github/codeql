const mkdirp = require('mkdirp');

export function test1(userName) {
  mkdirp('/some/dir/'+userName); // BAD
}

export function test2(filePath) {
  // GOOD (the name suggests it's a path)
  mkdirp('/some/dir/'+filePath);
}

export function test3({ filePath }) {
  // GOOD (the name suggests it's a path)
  mkdirp('/some/dir/'+filePath);
}
