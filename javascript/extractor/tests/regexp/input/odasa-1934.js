var r;

reportCompare(
  "x",
  (r = /[\x]+/.exec("x")) && r[0],
  "Section 1"
);