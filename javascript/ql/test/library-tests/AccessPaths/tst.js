function f(x) {
  let a = x.y.z;
  let b = x.y.z;
  let { y: c } = x;
  
  let y = x.y;
  let z = y.z;

  a;
  b;
  c;
  x;
  y;
  z;

  c.z;
}
