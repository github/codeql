function test(x, y) {
  let a = [];
  a.splice(source(), x);
  sink(a); // OK

  let b = [];
  b.splice(x, source());
  sink(b); // OK

  let c = [];
  c.splice(source(), x, y);
  sink(c); // OK

  let d = [];
  d.splice(x, source(), y);
  sink(d); // OK

  let e = [];
  e.splice(x, y, source());
  sink(e); // NOT OK

  let f = [];
  f.push(...source());
  sink(f); // NOT OK

  let g = [];
  g.unshift(...source());
  sink(g); // NOT OK

  let h = [];
  Array.prototype.push.apply(h, source());
  sink(h); // NOT OK

  let i = [];
  Array.prototype.unshift.apply(i, source());
  sink(i); // NOT OK
}
