function f(o) {
  var x = 42, y = null;
  with(o) {
    var r1 = x;
    var r2 = y;
    {
      let y = "hi";
      {
        var r3 = x;
        var r4 = y;
      }
    }
    var z = true;
    var r5 = z;
  }
  var r6 = x;
}