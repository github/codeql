(function () {
  var source = "tainted";
  var promise = new Promise(function (resolve, reject) {
    resolve(source);
  });
  promise.then(function (val) {
    var sink = val;
  });

  var promise2 = new Promise((res, rej) => {
    var res_source = "resolved";
    var rej_source = "rejected";
    if (Math.random() > .5)
      res(res_source);
    else
      rej(rej_source);
  });
  promise2.then((v) => {
    var res_sink = v;
  }, (v) => {
    var rej_sink = v;
  });
  promise2.catch((v) => {
    var rej_sink = v;
  });
  promise2.finally((v) => {
    var sink = v;
  });
})();

(function() {
    var Promise = require("bluebird");
    var promise = new Promise(function (resolve, reject) {
        resolve(source);
    });
    promise.then(function (val) {
        var sink = val;
    });
})();

(function() {
    var Q = require("q");
    var promise = Q.Promise(function (resolve, reject) {
        resolve(source);
    });
    promise.then(function (val) {
        var sink = val;
    });
})();

(function() {
    var source = "tainted";
    var promise = Promise.resolve(source);
    promise.then(function (val) {
        var sink = val;
    });
})();

(function() {
    var Promise = require("bluebird");
    var source = "tainted";
    var promise = Promise.resolve(source);
    promise.then(function (val) {
        var sink = val;
    });
})();

(function() {
    var Promise = goog.require('goog.Promise');
    var source = "tainted";
    Promise.resolve(source).then(val => { var sink = val; });
    new Promise((res,rej) => res(source)).then(val => { var sink = val });
    let resolver = Promise.withResolver();
    resolver.resolve(source);
    resolver.promise.then(val => { var sink = val });
})();

(function(source) {
    var promise = Promise.resolve(source);
    promise.then(function (val) {
        var sink = val;
    });
})();


(function() {
  var Q = require("kew");
  var promise = Q.Promise(function (resolve, reject) {
      resolve(source);
  });
  promise.then(function (val) {
      var sink = val;
  });
})();

(function() {
  var PromiseA = require('promise');
  var PromiseB = require('promise/domains');
  PromiseA.resolve(source);
  PromiseB.resolve(source);
})();

(function() {
  var PromiseA = require('promise-polyfill').default;
  import PromiseB from 'promise-polyfill';
  PromiseA.resolve(source);
  PromiseB.resolve(source);
})();

(function() {
  var RSVP = require('rsvp');
  var promise = new RSVP.Promise(function(resolve, reject) {});
  var Promise = require('es6-promise').Promise;
  Promise.resolve(source);
})();

(function() {
  var Promise = require('native-promise-only');
  Promise.resolve(source);
})();

(function() {
  const when = require('when');
  const promise = when(source);
  const promise2 = when.resolve(source);
})();

(function() {
  var Promise = require('pinkie-promise');
  var prom = new Promise(function (resolve) { resolve('unicorns'); });
})();

(function() {
  var Promise = require('pinkie');
  new Promise(function (resolve, reject) {
    resolve(data);
  });
})();

(function() {
  import { SynchronousPromise } from 'synchronous-promise';
  // is technically not a promise, but behaves like one.
  var promise = SynchronousPromise.resolve(source);
})();

(function() {
  var Promise = require('any-promise');
  return new Promise(function(resolve, reject){})
})();

(function() {
  var Promise = require('lie');
  var promise = Promise.resolve(source);
})();