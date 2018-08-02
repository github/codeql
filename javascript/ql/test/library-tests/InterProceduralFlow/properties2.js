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

// semmle-extractor-options: --source-type module
