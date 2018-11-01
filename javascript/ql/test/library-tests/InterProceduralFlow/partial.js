let underscore = require('underscore');
let lodash = require('lodash');
let R = require('ramda');

let source1 = "tainted1";
let source2 = "tainted2";

function f1(x, y) {
  let sink1 = x;
  let sink2 = y;
}
f1.bind(null, source1)(source2);

function f2(x, y) {
  let sink1 = x;
  let sink2 = y;
}
underscore.partial(f2, source1)(source2);

function f3(x, y) {
  let sink1 = x;
  let sink2 = y;
}
lodash.partial(f3, source1)(source2);

function f4(x, y) {
  let sink1 = x;
  let sink2 = y;
}
R.partial(f4, [source1])(source2);
