function sum(xs, i) {
  var res = 0;
  for(;i++<xs.length;) // $ Alert
    res += xs[0]; // BAD: should be xs[i]
  return res;
}
