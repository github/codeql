(function(b) {
  let f_ = f;
  let g1 = g;
  function f() {}

  if (b) {
    let g2 = g;
    function g() {}
  }
});
