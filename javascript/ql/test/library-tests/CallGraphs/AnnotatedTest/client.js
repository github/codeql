const lib = require("./lib"),
      { f } = require("./lib");

/** calls:lib.f */
lib.f();
/** calls:lib.f */
f();

(function() {
  /** calls:lib.f */
  f();
})();
