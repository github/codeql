(0).foo = 42; // $ Alert

null.bar = 23;  undefined.baz = 42; // OK - already flagged by SuspiciousPropAccess.ql

function f() {
  var s = "";
  for (var i=0;i<10;++i)
    s[i] = " "; // $ Alert
}

function g(b) {
  var x = b ? "" : 42, z;
  x.y = true; // $ Alert
  // OK - we don't know the type of `b`
  b.y = true;
  return;
  // OK - no types inferred for `z`, since this is dead code
  z.y = true;
}

function h() {
  let tmp;
  let obj = (tmp ||= {});
  obj.p = 42;
}
