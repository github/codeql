let bluebird = require('bluebird');

function test() {
  sink(Promise.resolve(source())); // NOT OK
  sink(bluebird.resolve(source())); // NOT OK
}

function closure() {
  let Promise = goog.require('goog.Promise');
  sink(Promise.resolve(source())); // NOT OK
  let resolver = Promise.withResolver();
  resolver.resolve(source());
  sink(resolver.promise); // NOT OK
}