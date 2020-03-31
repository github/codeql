import * as dummy from 'dummy';

function outer(x) {
  var shared;
  function a() {
    shared = x;
  }
  function b() {
    return shared + 'blah';
  }
  b(null);
  a();
  return b();
}
var source = "src1";
var sink = outer(source);

outer(null);
