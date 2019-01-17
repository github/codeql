let bluebird = require('bluebird');

function test() {
  sink(Promise.resolve(source())); // NOT OK
  sink(bluebird.resolve(source())); // NOT OK
}
