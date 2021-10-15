var Sup = class {
  constructor(x) {
    this.x = x;
    var ctor = new.target;
  }
}

class Sub extends Sup {
  constructor() {
    super(42)
  }

  foo() {
    return super.x;
  }
}

function f(...args) {
  var _args = args;
}

!function(x = 42){
  var _x = x;
}()

import { v } from './b';
var ohSoVery = v;

var r = tagged `template literal`;

(function(x, y, z) {
  var _x = x;
  var _y = y;
  var _z = z;
})(null, ...args, "hi");


(function(x, y, z) {
  var _x = x;
  var _y = y;
  var _z = z;
}).call(null, ...args, "hi");

(function() {
  var f = function*(){}();
  var x = async function(){}();
})

var req = require;
