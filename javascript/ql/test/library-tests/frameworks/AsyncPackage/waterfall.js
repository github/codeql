let async_ = require('async');
let waterfall = require('a-sync-waterfall');

var source, sink, somethingWrong;

async_.waterfall([
    function(callback) {
      callback(null, 'safe', source());
    },
    function(safe, taint, callback) {
      sink(taint); // NOT OK
      sink(safe);  // OK
      callback(null, taint, safe);
    },
    function(taint, safe, callback) {
      callback(null, taint, safe);
    }
  ],
  function finalCallback(err, taint, safe) {
    sink(taint); // NOT OK
    sink(safe);  // OK
  }
);

async_.waterfall([
    function(callback) {
      if (somethingWrong()) {
        callback(source());
      } else {
        callback(null, 'safe');
      }
    },
    function(safe, callback) {
      sink(safe); // OK
      callback(null, safe);
    }
  ],
  function(err, safe) {
    sink(err); // NOT OK
    sink(safe); // OK
  }
);

waterfall([
    function(callback) {
      callback(null, source());
    },
    function(taint, callback) {
      sink(taint); // NOT OK
      callback(null, taint);
    }
  ],
  function(err, taint) {
    sink(err); // OK
    sink(taint); // NOT OK
  }
);
