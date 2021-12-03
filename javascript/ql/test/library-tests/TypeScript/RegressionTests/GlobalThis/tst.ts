'use strict';

var _myGlobal = this;

module Test {
  var global = _myGlobal || {};

  export class C {}

  export function f(x: C) {
    global.field = x || {};
  }
}
