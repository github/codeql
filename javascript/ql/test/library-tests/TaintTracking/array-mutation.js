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

  let j = [];
  j[j.length] = source();
  sink(j); // NOT OK

  let k = [];
  let kSpliced = k.toSpliced(x, y, source());
  sink(k); // OK
  sink(kSpliced); // NOT OK

  let l = [];
  l = l.toSpliced(x, y, source());
  sink(l); // NOT OK

  let m = [];
  m = m.toSpliced(q, source(), y);
  sink(m); // OK

  let n = [];
  n = n.toSpliced(source(), x);
  sink(n); // OK

  let o = [];
  o = o.toSpliced(x, source());
  sink(o); // OK

  let p = [];
  p = p.toSpliced(source(), x, y);
  sink(p); // OK

  let q = [];
  q.splice(x, y, ...source());
  sink(q); // NOT OK

  let r = [];
  let rSpliced = r.toSpliced(x, y, ...source());
  sink(rSpliced); // NOT OK
  sink(r); // OK
  r = r.toSpliced(x, y, ...source());
  sink(r); // NOT OK
}
