function m0() {
  const x = source("m0.1");
  sink(x); // $ track=m0.1
}

function m1() {
  const fn = mkSummary("Argument[0]", "ReturnValue");
  const obj = source("m1.1");
  sink(fn(obj)); // $ MISSING: track=m1.1
  sink(fn(obj.p));
  sink(fn(obj).p);
  sink(fn({ p: obj }));
  sink(fn({ p: obj }).q);
}

function m2() {
  const fn = mkSummary("Argument[0].Member[p]", "ReturnValue");
  const obj = source("m2.1");
  sink(fn(obj));
  sink(fn(obj.p));
  sink(fn(obj).p);
  sink(fn({ p: obj })); // $ MISSING: track=m2.1
  sink(fn({ p: obj }).q);
}

function m3() {
  const fn = mkSummary("Argument[0]", "ReturnValue.Member[p]");
  const obj = source("m3.1");
  sink(fn(obj));
  sink(fn(obj.p));
  sink(fn(obj).p); // $ MISSING: track=m3.1
  sink(fn({ p: obj }));
  sink(fn({ p: obj }).q);
}


function m4() {
  const fn = mkSummary("Argument[0].Member[p]", "ReturnValue.Member[q]");
  const obj = source("m4.1");
  sink(fn(obj));
  sink(fn(obj.p));
  sink(fn(obj).p);
  sink(fn({ p: obj }));
  sink(fn({ p: obj }).q); // $ MISSING: track=m4.1
}
