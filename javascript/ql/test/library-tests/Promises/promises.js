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