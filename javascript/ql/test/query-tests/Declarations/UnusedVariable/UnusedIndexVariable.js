function sum(xs, i) {
  var res = 0;
  for(;i++<xs.length;) // OK - flagged by js/unused-index-variable
    res += xs[0];
  return res;
}
