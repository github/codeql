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

const limit = require('call-limit')
function f5(x, y) {
  let sink1 = x;
  let sink2 = y;
}
const limited = limit(f5, 5)
limited(source1, source2);

function f6(x, y) {
  let sink1 = x;
  let sink2 = y;
}
_.throttle(f6, 100)(source1, source2);

function f7(x, y) {
  let sink1 = x;
  let sink2 = y;
}
_.after(3, f7)(source1, source2);

function f8(x, y) {
  let sink1 = x;
  let sink2 = y;
}
require("throttle-debounce").debounce(1000, false, f8)(source1, source2);