const fs = require("fs");
(function () {
  unknown();
  toString();
  fs.readFile();

  function withCallback(cb) {
    cb();
  }
  withCallback(() => 42);

  let obj = { a: { b: { c: () => 42 } }, f: cb => cb() };
  obj.f(obj.a.b.c);
});

const _ = require("underscore"),
  cp = require("child_process");
(function () {
  let x = { p: 42 };
  [].push(x);
  _.map(x);
  cp.exec(x);
});

const mongoose = require('mongoose'),
  User = mongoose.model('User', null);

function main() {
  User.find({ 'isAdmin': true })
    .exec(function (err, adminUsers) {
      if (err || !adminUsers) {
        throw err;
      }

      for (var i = 0; i < adminUsers.length; i++) {
        console.log(adminUsers[i]);
      }
    });
}

function ready() {
  if (!o.async || x.readyState == 4 || c++ > 10000) {
    if (o.success && c < 10000 && x.status == 200)
      o.success.call(o.success_scope, '' + x.responseText, x, o);
    else if (o.error)
      o.error.call(o.error_scope, c > 10000 ? 'TIMED_OUT' : 'GENERAL', x, o);

    x = null;
 } else
 w.setTimeout(ready, 10);
};
