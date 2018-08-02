// NOT OK
(0).foo = 42;

// NOT OK, but already flagged by SuspiciousPropAccess.ql
null.bar = 23;  undefined.baz = 42;

function f() {
  var s = "";
  for (var i=0;i<10;++i)
    // NOT OK
    s[i] = " ";
}

function g(b) {
  var x = b ? "" : 42, z;
  // NOT OK
  x.y = true;
  // OK: we don't know the type of `b`
  b.y = true;
  return;
  // OK: no types inferred for `z`, since this is dead code
  z.y = true;
}