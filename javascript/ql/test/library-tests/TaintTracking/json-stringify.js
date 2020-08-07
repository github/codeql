function foo() {
  let source = source();
  let taint = source();

  sink(JSON.stringify(source)); // NOT OK

  var jsonStringifySafe = require("json-stringify-safe");
  sink(jsonStringifySafe(taint)); // NOT OK
  sink(require("json-stable-stringify")(source)); // NOT OK
  sink(require("stringify-object")(source)); // NOT OK
  sink(require("json3").stringify(source)); // NOT OK
  sink(require("fast-json-stable-stringify")(source)); // NOT OK
  sink(require("fast-safe-stringify")(source)); // NOT OK
  sink(require("javascript-stringify")(source)); // NOT OK
  sink(require("js-stringify")(source)); // NOT OK
  sink(require("util").inspect(source)); // NOT OK
  sink(require("pretty-format")(source)); // NOT OK
  sink(require("object-inspect")(source)); // NOT OK
}
