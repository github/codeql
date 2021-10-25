function foo(x) {
  return {
    p: x
  };
}

var source = "source";
var sink = foo(source).p;
var sink2 = foo("not a source").p;

function setP(base, rhs) {
  base.p = rhs;
}

var o = {};
setP(o, source);
var sink3 = o.p;  // flow from `source` not yet detected
var sink4 = o.q;

var o2 = {};
setP(o2, "not a source");
var sink5 = o2.p;

function getP(base) {
  return base.p;
}

function getQ(base) {
  return base.q;
}

var o3 = { p: source };
var sink6 = getP(o3);
var sink7 = getQ(o3);

var o4 = {};
setP(o4, source);
var sink8 = getP(o4);
var sink9 = getQ(o4);

var o5 = {};
setP(o5, "not a source");
var sink10 = getP(o5);

export default 0;
