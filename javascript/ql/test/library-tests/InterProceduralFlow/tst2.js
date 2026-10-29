(function() {
  let source1 = "tainted1";
  let source2 = "tainted2";

  function g(x) {
    let other_source = "also tainted";
    return Math.random() > .5 ? x : other_source;
  }

  let sink1 = g(source1);
  let sink2 = g(source2);
});
