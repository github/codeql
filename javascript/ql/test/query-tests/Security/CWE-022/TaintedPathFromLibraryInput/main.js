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

export function mkdir(filePath) {
  // GOOD (There is a flow from the input to a sink, BUT the flow does
  // not go through any string concatenations. It is therefore likely that
  // the flow is intentional.)
  mkdirp(filePath)
}
