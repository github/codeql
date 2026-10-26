function sum(xs) {
  var res = 0;
  for(var i=0; i<xs.length; ++i)
    res += xs[0]; // BAD: should be xs[i]
  return res;
}
