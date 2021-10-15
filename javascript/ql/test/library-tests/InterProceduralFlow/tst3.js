(function() {
  let source1 = "tainted1";
  function noReturnTracking1(x) {
    return x;
  }
  let sink1 = noReturnTracking1(source1);

  function noReturnTracking2() {
    let source2 = "tainted2";
    return source2;
  }
  let sink2 = noReturnTracking2();
});
