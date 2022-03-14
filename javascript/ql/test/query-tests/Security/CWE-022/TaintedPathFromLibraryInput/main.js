const mkdirp = require('mkdirp');

export function test(userName) {
  mkdirp('/some/dir/'+userName); // BAD
}
