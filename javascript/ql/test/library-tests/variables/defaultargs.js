(function() {
  var x, arguments;
  function f(x, y = x) {}
  function g(x = arguments[1], y = arguments[0]) {}
})();