function f() {}           // "function f"
!function g() {}          // "function g"
(function() {})()         // "anonymous function"
var h = function () {};   // "function h"
let k = x => x,           // "function k"
    m = function n() {};  // "function n"

var o = {
  p: function() {},       // "method p"
  q: function f() {},     // "function f"
  get x() {},             // "getter for property x"
  set x(v) {},            // "setter for property x"
  m() {}                  // "method m"
};

class C {                 // "class C"
  constructor() {}        // "constructor of class C"
  n() {}                  // "method n of class C"
}

!class D                  // "class D", "default constructor of class D"
  extends (class{}) {     // "anonymous class", "default constructor of anonymous class"
}

const E = class {},       // "class E", "default constructor of class E"
      F = class G {       // "class G", "default constructor of class G"
  get y() {}              // "getter method for property y of class G"
  set y(v) {}             // "setter method for property y of class G"
};

o.foo = function() {};    // "method foo"
o["Hey"] = function() {}; // "anonymous function"

o.Foo = class {};         // "class Foo"
