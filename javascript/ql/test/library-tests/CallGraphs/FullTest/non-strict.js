(function () {
  if (true) {
    function foo() {
      return 3;
    }
  }
  return foo(); // this resolves to `foo` above, because we have function-scope in non-strict mode.
})();