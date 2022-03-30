function k() {
  var x = 42;
  eval("x = 23");
  x;               // incompleteness due to `eval`
}