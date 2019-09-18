goog.module('enumuse');

let fooBar = goog.require('foo.bar');

fooBar.x.y.z;

function infinite() {
  let z = fooBar;
  while (z) {
    z = z.x;
  }
}
