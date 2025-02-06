var o = {
  A: function f(x) {
       'use strict';
       if (!(this instanceof arguments.callee)) // $ Alert
         return new arguments.callee(x); // $ Alert
       console.log(f.caller); // $ Alert
       this.y = f.arguments; // $ Alert
       this.x = x;
     }
};

var D = class extends function() {
  return arguments.callee; // $ Alert
} {};

function g() {

  return arguments.caller.length;
}

(function() {
  'use strict';
  function h() {
    var foo = Math.random() > 0.5 ? h : arguments;
    return foo.caller; // $ Alert
  }
})();

(function() {
  'use strict';
  arguments.caller; // OK - avoid duplicate alert from useless-expression
})();
