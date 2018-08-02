// this toplevel is not strict

// this function is not strict
function f() {
}

// this function is strict
function g() {
  'use strict';
  // this function is strict
  function h() {
  }
}

class C extends
  (
   console.log("Did you know `extends` clauses can contain arbitrary expressions?"),
   // this function is strict
   function k() {}
  ) {
  // this function is strict
  constructor() { this.x = 42; }
  // this function is strict
  l() { this.x = 23; }
}