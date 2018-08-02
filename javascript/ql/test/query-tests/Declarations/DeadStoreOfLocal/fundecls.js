(function f(b) {
  if (b) {
    console.log(g.length);  // fine both in v8 and in SpiderMonkey
    function g() {}
  }
}(true));
