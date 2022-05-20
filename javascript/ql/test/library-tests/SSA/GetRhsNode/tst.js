function f() {
  let a = g();
  
  let { propB: b } = g();

  let { propC: c, propD: d } = g();
  
  let { arrayProp: [ elm1, elm2 ] } = g();
  
  a; // Ensure variables are live.
  b;
  c;
  d;
  elm1;
  elm2;

  ({ propB: b }) = g();
  
  ({ propC: c, propD: d }) = g();
  
  [ elm1, elm2 ] = g();
  
  a;
  b;
  c;
  d;
  elm1;
  elm2;
}

function h([elm1, elm2], { prop: value }) {
  elm1;
  elm2;
  value;
}
