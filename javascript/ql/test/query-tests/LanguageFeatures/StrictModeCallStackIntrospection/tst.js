var o = {
  A: function f(x) {
       'use strict';
       // BAD
       if (!(this instanceof arguments.callee))
         // BAD
         return new arguments.callee(x);
       // BAD
       console.log(f.caller);
       // BAD
       this.y = f.arguments;
       this.x = x;
     }
};

var D = class extends function() {
  // BAD
  return arguments.callee;
} {};

function g() {
  // OK
  return arguments.caller.length;
}

(function() {
  'use strict';
  function h() {
    var foo = Math.random() > 0.5 ? h : arguments;
    // BAD
    return foo.caller;
  }
})();

(function() {
  'use strict';
  arguments.caller; // OK - avoid duplicate alert from useless-expression
})();
