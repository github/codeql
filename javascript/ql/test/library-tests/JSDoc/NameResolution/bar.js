function test() {
  let x = ns.very.long.namespace;

  /**
   * @param {x.Foo} foo
   */
  function f(foo) {}
}

(function(iife) {
  /**
   * @param {iife.Foo} foo
   */
  function f(foo) {}
})(IIFE);
