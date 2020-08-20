"use strict";
(function () {
  "use strict";
  if (true) {
    function foo() {
      return 3;
    }
  }
  return foo(); // `foo` is not defined, because we are in strict-mode.
})();

export default 3; // strict-mode implied because ES2015 module.